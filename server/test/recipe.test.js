const request = require('supertest');
const app = require('../server');
const mariadb = require('mariadb');

const conn =  mariadb.createPool({
  host: process.env.DATABASE_HOST, 
  user: process.env.DATABASE_USER,
  password: process.env.DATABASE_PASSWORD,
  database: process.env.DATABASE_NAME
});

beforeAll(async () => {
  await conn.query("DELETE FROM recipes WHERE 1=1;");
  await conn.query("INSERT INTO recipes VALUES (null, 'test_recipe1', 'test', 0, 0, 1, true, true, false, false, false, false, false);");
  await conn.query("INSERT INTO recipes VALUES (null, 'test_recipe2', 'test', 0, 0, 1, true, true, false, false, false, false, false);");
  await conn.query("INSERT INTO recipes VALUES (null, 'test_recipe3', 'test', 0, 0, 1, true, true, false, false, false, false, false);");
});

afterAll(async () => {
  conn.end();
  app.closeServer();
});



describe('GET recipe/:id', () => {
  it('call on undifined recipe_id', async () => {
    const res = await request(app).get('/recipe/PO');
    expect(res.status).toBe(405);
    expect(res.text).toBe("undifined recipe_id");
  });
  it('call on good parameters with last recipe', async () => {
    const last_recipe = await request(app).get('/recipe/last');
    console.log(last_recipe.body["id"]);
    const res = await request(app).get('/recipe/'+last_recipe.body["id"]).send({recipe_id:last_recipe.body["id"]});
    expect(res.status).toBe(200);
  })
})
