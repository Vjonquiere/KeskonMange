const request = require('supertest');
const app = require('../server');
const mariadb = require('mariadb');

const conn =  mariadb.createPool({
  host: process.env.DATABASE_HOST, 
  user: process.env.DATABASE_USER,
  password: process.env.DATABASE_PASSWORD,
  database: process.env.DATABASE_NAME
});

function dateFromToday(days){ // add days day to current date
    let current = new Date();
    let date = new Date();
    date.setDate(current.getDate() + days)
    return date.toISOString().split('T')[0];
}

beforeAll(async () => {
    
    await conn.query("DELETE FROM calendar WHERE 1=1;");
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
    app.closeServer();
});



describe('GET calendar/today', () => {
  it('simple call', async () => {
    const res = await request(app).get('/calendar/today').send();
    expect(res.status).toBe(200);
    expect(res.text).toBe(`{\"recipe\":[{\"date\":\"${dateFromToday(-1)}T22:00:00.000Z\",\"recipeId\":0,\"done\":0,\"result_img\":\"path/to/image\"}]}`); // Given entry formatted to JSON
  });
});

describe('GET calendar/coming', () => {
    it('call on known value (day+1)', async () => {
      const res = await request(app).get('/calendar/coming?days=1').send();
      expect(res.status).toBe(200);
      expect(res.text).toBe(`{\"recipe\":[{\"date\":\"${dateFromToday(0)}T22:00:00.000Z\",\"recipeId\":4,\"done\":1,\"result_img\":\"path/to/image\"}]}`); // Given entry formatted to JSON
    });
    it('call on known value (negative day number) (day-1)', async () => {
        const res = await request(app).get('/calendar/coming?days=-1').send();
        expect(res.status).toBe(200);
        expect(res.text).toBe(`{\"recipe\":[{\"date\":\"${dateFromToday(-2)}T22:00:00.000Z\",\"recipeId\":1,\"done\":1,\"result_img\":\"path/to/image\"}]}`); // Given entry formatted to JSON
      });
    it('call on known value with no recipe (day+10)', async () => {
        const res = await request(app).get('/calendar/coming?days=10').send();
        expect(res.status).toBe(204);
      });
  });