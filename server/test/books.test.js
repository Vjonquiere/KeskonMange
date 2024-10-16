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
  await conn.query('DELETE FROM recipe_books WHERE 1=1;');
  await conn.query('DELETE FROM recipe_book_access WHERE 1=1;');
  await conn.query('DELETE FROM recipe_book_links WHERE 1=1;');
})

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


describe('DELETE books/delete', () => {
  it('simple call', async () => {
    const res = await request(app).post('/books/create?name=testDelete').send();
    expect(res.status).toBe(200);
    const check = await request(app).get('/books/id?bookName=testDelete').send(); // check if we can get id of the book
    expect(check.status).toBe(200);
    const check2 = await request(app).delete(`/books/delete?bookId=${JSON.parse(check.text)["id"]}`).send(); // check if book can be deleted
    expect(check2.status).toBe(200);
  });
  it('call on missing argument', async () => {
    const check2 = await request(app).delete(`/books/delete`).send(); // BookId not specified
    expect(check2.status).toBe(400);
  });
  it('call on not indexed bookId', async () => {
    const check2 = await request(app).delete(`/books/delete?bookId=test3`).send();
    expect(check2.status).toBe(200);
  });  
});

describe('POST books/share', () => {
  it('simple call', async () => {
    const res = await request(app).post('/books/create?name=test2').send();
    expect(res.status).toBe(200);
    const check = await request(app).get('/books/id?bookName=test2').send(); // check if we can get id of the book
    expect(check.status).toBe(200);
    const share = await request(app).post(`/books/share?bookId=${JSON.parse(check.text)["id"]}&userId=23`).send();
    expect(share.status).toBe(200);
  });  
  it('call on missing argument (bookId)', async () => {
    const share = await request(app).post(`/books/share?userId=23`).send();
    expect(share.status).toBe(400);
  });
  it('call on missing argument (userId)', async () => {
    const res = await request(app).post('/books/create?name=test3').send();
    expect(res.status).toBe(200);
    const check = await request(app).get('/books/id?bookName=test3').send(); // check if we can get id of the book
    expect(check.status).toBe(200);
    const share = await request(app).post(`/books/share?bookId=${JSON.parse(check.text)["id"]}`).send();
    expect(share.status).toBe(400);
  });
  it('call on wrong bookId', async () => {
    const res = await request(app).post('/books/create?name=test4').send();
    expect(res.status).toBe(200);
    const check = await request(app).get('/books/id?bookName=test4').send(); // check if we can get id of the book
    expect(check.status).toBe(200);
    const share = await request(app).post(`/books/share?bookId=${JSON.parse(check.text)["id"]+1000}&userId=23`).send(); // DB is reset before testing -> number of recipe books <1000 
    expect(share.status).toBe(500);
  });
})

describe('POST books/recipe/add', () => {
  it('simple call', async () => {
    const res = await request(app).post('/books/create?name=recipeAddTest').send();
    expect(res.status).toBe(200);
    const check = await request(app).get('/books/id?bookName=recipeAddTest').send();
    expect(check.status).toBe(200);
    const add = await request(app).post(`/books/recipe/add?bookId=${JSON.parse(check.text)["id"]}&recipeId=21`).send();
    expect(add.status).toBe(200);
  });
  it('add to unknown book', async () => {
    const check = await request(app).get('/books/id?bookName=recipeAddTest').send();
    expect(check.status).toBe(200);
    const add = await request(app).post(`/books/recipe/add?bookId=${JSON.parse(check.text)["id"]+1000}&recipeId=21`).send();
    expect(add.status).toBe(500);
    expect(add.text).toBe("Can't add recipe to given book: no matching id");
  });
})