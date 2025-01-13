const request = require('supertest');
const app = require('../server');
const mariadb = require('mariadb');
const utils = require('./utils');
const login = require('./login');
const ApiKeyHash = require('../module/token').getApiKeyHash;

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

let ID;
let userId;

beforeAll(async () => {
    
    //await conn.query("DELETE FROM calendar WHERE 1=1;");
    await utils.clearDatabase();
    ID = await login.getCredentials();
    userId = (await conn.query("SELECT userId FROM authentication WHERE token = ?;", [ApiKeyHash(ID['x-api-key'])]))[0].userId;
    // Sample data for self-adapt data
    await conn.query(`INSERT INTO calendar VALUES ('${dateFromToday(0)}', 0, 0, 'path/to/image', ?);`, [userId]);
    await conn.query(`INSERT INTO calendar VALUES ('${dateFromToday(1)}', 4, 1, 'path/to/image', ?);`, [userId]);
    await conn.query(`INSERT INTO calendar VALUES ('${dateFromToday(-1)}', 1, 1, 'path/to/image', ?);`, [userId]);
    await conn.query(`INSERT INTO calendar VALUES ('${dateFromToday(3)}', 5, 0, 'path/to/image', ?);`, [userId]);
    // Sample data for September 2024
    await conn.query(`INSERT INTO calendar VALUES ('2024-09-01', 0, 0, 'path/to/image', ?);`, [userId]);
    await conn.query(`INSERT INTO calendar VALUES ('2024-09-02', 4, 1, 'path/to/image', ?);`, [userId]);
    await conn.query(`INSERT INTO calendar VALUES ('2024-09-03', 1, 1, 'path/to/image', ?);`, [userId]);
    await conn.query(`INSERT INTO calendar VALUES ('2024-09-04', 5, 0, 'path/to/image', ?);`, [userId]);
    // Sample data for other months
    await conn.query(`INSERT INTO calendar VALUES ('2023-01-03', 1, 4, 'path/to/image', ?);`, [userId]);
    await conn.query(`INSERT INTO calendar VALUES ('2023-12-20', 6, 1, 'path/to/image', ?);`, [userId]);
    await conn.query(`INSERT INTO calendar VALUES ('2022-09-03', 1, 4, 'path/to/image', ?);`, [userId]);

});

afterAll(async () => {
    conn.end();
    utils.end_connexion();
    app.closeServer();
});



describe('GET calendar/today', () => {
  it('simple call', async () => {
    const res = await request(app).get('/calendar/today').set(ID).send();
    expect(res.status).toBe(200);
    expect(res.text).toBe(`{\"recipe\":[{\"date\":\"${dateFromToday(0)}\",\"recipeId\":0,\"done\":0,\"result_img\":\"path/to/image\"}]}`); // Given entry formatted to JSON
  });
  it('call with no recipe defined', async () => {
    await conn.query(`DELETE FROM calendar WHERE date = '${dateFromToday(0)}';`);
    const res = await request(app).get('/calendar/today').set(ID).send();
    expect(res.status).toBe(204);
    await conn.query(`INSERT INTO calendar VALUES ('${dateFromToday(0)}', 0, 0, 'path/to/image', ?);`, [userId]);
  });
});

describe('GET calendar/coming', () => {
    it('call on known value (day+1)', async () => {
      const res = await request(app).get('/calendar/coming?days=1').set(ID).send();
      expect(res.status).toBe(200);
      expect(res.text).toBe(`{\"recipe\":[{\"date\":\"${dateFromToday(1)}\",\"recipeId\":4,\"done\":1,\"result_img\":\"path/to/image\"}]}`); // Given entry formatted to JSON
    });
    it('call on known value (negative day number) (day-1)', async () => {
        const res = await request(app).get('/calendar/coming?days=-1').set(ID).send();
        expect(res.status).toBe(200);
        expect(res.text).toBe(`{\"recipe\":[{\"date\":\"${dateFromToday(-1)}\",\"recipeId\":1,\"done\":1,\"result_img\":\"path/to/image\"}]}`); // Given entry formatted to JSON
      });
    it('call on known value with no recipe (day+10)', async () => {
        const res = await request(app).get('/calendar/coming?days=10').set(ID).send();
        expect(res.status).toBe(204);
      });
    it('call on day not a number', async () => {
      const res = await request(app).get('/calendar/coming?days=Nan').set(ID).send();
      expect(res.status).toBe(405);
    });
  });

describe('GET calendar/next', () => {
  it('simple call', async () => {
    const res = await request(app).get('/calendar/next?count=2').set(ID).send();
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
    const res = await request(app).get('/calendar/next?count=3').set(ID).send();
    expect(res.status).toBe(200);
    let response = JSON.parse(res.text);
    expect(response["recipes"].length).toBe(2);
    expect(response["recipes"][0].length).toBe(2); // must have recipeId + date
  });
  it('call on non number count', async () => {
    const res = await request(app).get('/calendar/next?count=er').set(ID).send();
    expect(res.status).toBe(405);
  });
  it('call on negative count', async () => {
    const res = await request(app).get('/calendar/next?count=-1').set(ID).send();
    expect(res.status).toBe(405);
  });
  it('call on null count', async () => {
    const res = await request(app).get('/calendar/next?count=0').set(ID).send();
    expect(res.status).toBe(405);
  });
  it('call on +10 count', async () => {
    const res = await request(app).get('/calendar/next?count=11').set(ID).send();
    expect(res.status).toBe(405);
  });
  it('call with no next recipe defined', async () => {
    await conn.query(`DELETE FROM calendar WHERE date = '${dateFromToday(1)}';`); // removing known entries
    await conn.query(`DELETE FROM calendar WHERE date = '${dateFromToday(3)}';`);
    const res = await request(app).get('/calendar/next?count=2').set(ID).send();
    expect(res.status).toBe(204);
    await conn.query(`INSERT INTO calendar VALUES ('${dateFromToday(0)}', 0, 0, 'path/to/image', ?);`, [userId]);
    await conn.query(`INSERT INTO calendar VALUES ('${dateFromToday(3)}', 5, 0, 'path/to/image', ?);`, [userId]);
  });
});

describe('GET calendar/completeMonth', () => {
  it('simple call', async () => {
    const res = await request(app).get('/calendar/completeMonth?previous=0').set(ID).send();
    let data = JSON.parse(res.text);
    let date = new Date();
    expect(data["year"]).toBe(date.getFullYear());
    expect(data["month"]).toBe(date.getMonth()+1); // +1 because Date.getMonth is between 0-11 and 1-12 for our request 
    expect(res.status).toBe(200);
  });
  it('call on missing argument (previous)', async () => {
    const res = await request(app).get('/calendar/completeMonth').set(ID).send();
    expect(res.status).toBe(405);
  });
  it('call on wrong argument (previous)', async () => {
    const res = await request(app).get('/calendar/completeMonth?previous=Nan').set(ID).send();
    expect(res.status).toBe(405);
  });
  it('call on empty month', async () => {
    const res = await request(app).get('/calendar/completeMonth?previous=-2').set(ID).send(); // -2 to get 2 months in the future
    expect(res.status).toBe(204); // No recipes found for the given month
  });
})