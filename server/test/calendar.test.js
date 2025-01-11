const request = require('supertest');
const app = require('../server');
const mariadb = require('mariadb');
const utils = require('./utils');

const conn =  mariadb.createPool({
  host: process.env.DATABASE_HOST, 
  user: process.env.DATABASE_USER,
  password: process.env.DATABASE_PASSWORD,
  database: process.env.DATABASE_NAME,
  dateStrings: true
});

function dateFromToday(days){ // add days day to current date
    let current = new Date();
    let date = new Date();
    date.setDate(current.getDate() + days)
    return date.toISOString().split('T')[0];
}

beforeAll(async () => {
    
    //await conn.query("DELETE FROM calendar WHERE 1=1;");
    await utils.clearDatabase();
    // Sample data for self-adapt data
    await conn.query(`INSERT INTO calendar VALUES ('${dateFromToday(0)}', 0, 0, 'path/to/image');`);
    await conn.query(`INSERT INTO calendar VALUES ('${dateFromToday(1)}', 4, 1, 'path/to/image');`);
    await conn.query(`INSERT INTO calendar VALUES ('${dateFromToday(-1)}', 1, 1, 'path/to/image');`);
    await conn.query(`INSERT INTO calendar VALUES ('${dateFromToday(3)}', 5, 0, 'path/to/image');`);
    // Sample data for September 2024
    await conn.query(`INSERT INTO calendar VALUES ('2024-09-01', 0, 0, 'path/to/image');`);
    await conn.query(`INSERT INTO calendar VALUES ('2024-09-02', 4, 1, 'path/to/image');`);
    await conn.query(`INSERT INTO calendar VALUES ('2024-09-03', 1, 1, 'path/to/image');`);
    await conn.query(`INSERT INTO calendar VALUES ('2024-09-04', 5, 0, 'path/to/image');`);
    // Sample data for other months
    await conn.query(`INSERT INTO calendar VALUES ('2023-01-03', 1, 4, 'path/to/image');`);
    await conn.query(`INSERT INTO calendar VALUES ('2023-12-20', 6, 1, 'path/to/image');`);
    await conn.query(`INSERT INTO calendar VALUES ('2022-09-03', 1, 4, 'path/to/image');`);

});

afterAll(async () => {
    conn.end();
    utils.end_connexion();
    app.closeServer();
});



describe('GET calendar/today', () => {
  it('simple call', async () => {
    const res = await request(app).get('/calendar/today').send();
    expect(res.status).toBe(200);
    expect(res.text).toBe(`{\"recipe\":[{\"date\":\"${dateFromToday(0)}\",\"recipeId\":0,\"done\":0,\"result_img\":\"path/to/image\"}]}`); // Given entry formatted to JSON
  });
  it('call with no recipe defined', async () => {
    await conn.query(`DELETE FROM calendar WHERE date = '${dateFromToday(0)}';`);
    const res = await request(app).get('/calendar/today').send();
    expect(res.status).toBe(204);
    await conn.query(`INSERT INTO calendar VALUES ('${dateFromToday(0)}', 0, 0, 'path/to/image');`);
  });
});

describe('GET calendar/coming', () => {
    it('call on known value (day+1)', async () => {
      const res = await request(app).get('/calendar/coming?days=1').send();
      expect(res.status).toBe(200);
      expect(res.text).toBe(`{\"recipe\":[{\"date\":\"${dateFromToday(1)}\",\"recipeId\":4,\"done\":1,\"result_img\":\"path/to/image\"}]}`); // Given entry formatted to JSON
    });
    it('call on known value (negative day number) (day-1)', async () => {
        const res = await request(app).get('/calendar/coming?days=-1').send();
        expect(res.status).toBe(200);
        expect(res.text).toBe(`{\"recipe\":[{\"date\":\"${dateFromToday(-1)}\",\"recipeId\":1,\"done\":1,\"result_img\":\"path/to/image\"}]}`); // Given entry formatted to JSON
      });
    it('call on known value with no recipe (day+10)', async () => {
        const res = await request(app).get('/calendar/coming?days=10').send();
        expect(res.status).toBe(204);
      });
    it('call on day not a number', async () => {
      const res = await request(app).get('/calendar/coming?days=Nan').send();
      expect(res.status).toBe(405);
    });
  });

describe('GET calendar/next', () => {
  it('simple call', async () => {
    const res = await request(app).get('/calendar/next?count=2').send();
    expect(res.status).toBe(200);
    let response = JSON.parse(res.text);
    expect(response["recipes"].length).toBe(2); // return 2 entries
    expect(response["recipes"][0].length).toBe(2); // must have recipeId + date
    expect(response["recipes"][0][0]).toBe(4);
    expect(response["recipes"][0][1]).toBe(dateFromToday(1));
    expect(response["recipes"][1][0]).toBe(5);
    expect(response["recipes"][1][1]).toBe(dateFromToday(3));
  });
  it('simple call (not enough entries for given date)', async () => {
    const res = await request(app).get('/calendar/next?count=3').send();
    expect(res.status).toBe(200);
    let response = JSON.parse(res.text);
    expect(response["recipes"].length).toBe(2);
    expect(response["recipes"][0].length).toBe(2); // must have recipeId + date
  });
  it('call on non number count', async () => {
    const res = await request(app).get('/calendar/next?count=er').send();
    expect(res.status).toBe(405);
  });
  it('call on negative count', async () => {
    const res = await request(app).get('/calendar/next?count=-1').send();
    expect(res.status).toBe(405);
  });
  it('call on null count', async () => {
    const res = await request(app).get('/calendar/next?count=0').send();
    expect(res.status).toBe(405);
  });
  it('call on +10 count', async () => {
    const res = await request(app).get('/calendar/next?count=11').send();
    expect(res.status).toBe(405);
  });
  it('call with no next recipe defined', async () => {
    await conn.query(`DELETE FROM calendar WHERE date = '${dateFromToday(1)}';`); // removing known entries
    await conn.query(`DELETE FROM calendar WHERE date = '${dateFromToday(3)}';`);
    const res = await request(app).get('/calendar/next?count=2').send();
    expect(res.status).toBe(204);
    await conn.query(`INSERT INTO calendar VALUES ('${dateFromToday(0)}', 0, 0, 'path/to/image');`);
    await conn.query(`INSERT INTO calendar VALUES ('${dateFromToday(3)}', 5, 0, 'path/to/image');`);
  });
});

describe('GET calendar/completeMonth', () => {
  it('simple call', async () => {
    const res = await request(app).get('/calendar/completeMonth?previous=0').send();
    let data = JSON.parse(res.text);
    let date = new Date();
    expect(data["year"]).toBe(date.getFullYear());
    expect(data["month"]).toBe(date.getMonth()+1); // +1 because Date.getMonth is between 0-11 and 1-12 for our request 
    expect(res.status).toBe(200);
  });
  it('call on missing argument (previous)', async () => {
    const res = await request(app).get('/calendar/completeMonth').send();
    expect(res.status).toBe(405);
  });
  it('call on wrong argument (previous)', async () => {
    const res = await request(app).get('/calendar/completeMonth?previous=Nan').send();
    expect(res.status).toBe(405);
  });
  it('call on empty month', async () => {
    const res = await request(app).get('/calendar/completeMonth?previous=-2').send(); // -2 to get 2 months in the future
    expect(res.status).toBe(204); // No recipes found for the given month
  });
})