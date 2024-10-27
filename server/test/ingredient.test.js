const request = require('supertest');
const app = require('../server');
const mariadb = require('mariadb');

const conn =  mariadb.createPool({
  host: process.env.DATABASE_HOST, 
  user: process.env.DATABASE_USER,
  password: process.env.DATABASE_PASSWORD,
  database: process.env.DATABASE_NAME,
  dateStrings: true
});

beforeAll(async () => {
  await conn.query("DELETE FROM ingredients WHERE 1=1;");
  await conn.query("INSERT INTO ingredients VALUES (null,'test','liquid');");
  /*await conn.query("INSERT INTO recipes VALUES (null, 'test_recipe2', 'test', 0, 0, 1, true, true, false, false, false, false, false);");
  await conn.query("INSERT INTO recipes VALUES (null, 'test_recipe3', 'test', 0, 0, 1, true, true, false, false, false, false, false);");*/
});

afterAll(async () => {
  conn.end();
  app.closeServer();
});



describe('POST ingredient/add', () => {
  it('call on valid arguments', async () => {
    const res = await request(app).post('/ingredient/add').send({ name: "Poivron", type: "vegetable" });
    expect(res.status).toBe(200);
    expect(res.text).toBe("ingredient added");
  });
  it('call two times to check for double entry', async () => {
    const res = await request(app).post('/ingredient/add').send({ name: "Tomate", type: "vegetable" });
    expect(res.status).toBe(200);
    expect(res.text).toBe("ingredient added");
    const res2 = await request(app).post('/ingredient/add').send({ name: "Tomate", type: "vegetable" });
    expect(res2.status).toBe(200);
    expect(res2.text).toBe("ingredient already indexed");
  });
  it('call on invalid ingredient name', async () => {
    const res = await request(app).post('/ingredient/add').send({ name: 1, type: "liquid" });
    expect(res.status).toBe(405);
  });
  it('call on invalid ingredient type', async () => {
    const res = await request(app).post('/ingredient/add').send({ name: "Poivre", type: "invalid" });
    expect(res.status).toBe(405);
    expect(res.text).toBe("given type is invalid");
  });
  it('call with undefined name', async () => {
    const res = await request(app).post('/ingredient/add').send({type: "liquid"});
    expect(res.status).toBe(405);
  });
  it('call with undefined type', async () => {
    const res = await request(app).post('/ingredient/add').send({name: "Avocat"});
    expect(res.status).toBe(405);
  });
  it('call with undefined name + type', async () => {
    const res = await request(app).post('/ingredient/add').send();
    expect(res.status).toBe(405);
  })
});

describe('GET ingredient/name', () => {
    it('call on valid ingredient name', async () => {
      const res = await request(app).get('/ingredient/name/?name=test');
      expect(res.status).toBe(200);
    });
    it('call with empty name', async () => {
      const res = await request(app).get('/ingredient/name/');
      expect(res.status).toBe(405);
    });
    it('call with unknown name', async () => {
        const res = await request(app).get('/ingredient/name/?name=test2');
        expect(res.status).toBe(204);
    })
})
  
describe('GET ingredient/units', () => {
  it('call on valid ingredient name', async () => {
    const res = await request(app).get('/ingredient/units?name=test');
    expect(res.status).toBe(200);
    expect(JSON.parse(res.body)).toMatchObject({units:["l", "g"]}); // TODO: Need other test method (test may return false if array values are reversed)
  });
  it('call on unknown ingredient', async () => {
    const res = await request(app).get('/ingredient/units?name=unknown_ingredient');
    expect(res.status).toBe(204);
  });
  it('call on missing argument (name)', async () => {
    const res = await request(app).get('/ingredient/units');
    expect(res.status).toBe(405);
  });
})
