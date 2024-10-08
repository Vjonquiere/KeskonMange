const request = require('supertest');
const app = require('../server');
const mariadb = require('mariadb');

const conn =  mariadb.createPool({
  host: process.env.DATABASE_HOST, 
  user: process.env.DATABASE_USER,
  password: process.env.DATABASE_PASSWORD,
  database: process.env.DATABASE_NAME
});

afterAll(async () => {
    conn.end();
    app.closeServer();
});

describe('POST books/create', () => {
    it('simple call', async () => {
      const res = await request(app).post('/books/create?name=test').send();
      expect(res.status).toBe(200);
      const check = await request(app).get('/books/id?bookName=test').send(); // check if we can get id of the book
      expect(check.status).toBe(200);
      const check2 = await request(app).get(`/books/general_information?bookId=${JSON.parse(check.text)["id"]}`).send(); // check link between bookId and book name
      expect(JSON.parse(check2.text)["name"]).toBe("test");
    });
    it('call on wrong argument (illegal char)', async () => {
        const res = await request(app).post('/books/create?name=test^z').send();
        expect(res.status).toBe(400);
      });
    it('call on wrong argument (invalid len)', async () => {
        const res = await request(app).post('/books/create?name=theNameOfThisBookIsSoLoooooooooooong').send();
        expect(res.status).toBe(400);
    });
    it('call on missing argument', async () => {
        const res = await request(app).post('/books/create').send();
        expect(res.status).toBe(400);
    });
    /*
    When auth available need to check if book is linked to user
    */
});

  