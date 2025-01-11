const request = require('supertest');
const app = require('../server');
const mariadb = require('mariadb');
const login = require('./login');
const utils = require('./utils');

const conn =  mariadb.createPool({
  host: process.env.DATABASE_HOST, 
  user: process.env.DATABASE_USER,
  password: process.env.DATABASE_PASSWORD,
  database: process.env.DATABASE_NAME
});

let ID;

beforeAll(async () => {
  ID = await login.getCredentials();
  await utils.clearDatabase();
  /*await conn.query('DELETE FROM recipe_books WHERE 1=1;');
  await conn.query('DELETE FROM recipe_book_access WHERE 1=1;');
  await conn.query('DELETE FROM recipe_book_links WHERE 1=1;');*/
  await conn.query('ALTER TABLE recipe_books AUTO_INCREMENT = 0;');
})


afterAll(async () => {
    utils.end_connexion();
    conn.end();
    app.closeServer();
});

describe('POST books/create', () => {
    it('simple call', async () => {
      const res = await request(app).post('/books/create?name=test').set(ID).send();
      expect(res.status).toBe(200);
      const check = await request(app).get('/books/id?bookName=test').set(ID).send(); // check if we can get id of the book
      expect(check.status).toBe(200);
      const check2 = await request(app).get(`/books/general_information?bookId=${JSON.parse(check.text)["id"]}`).set(ID).send(); // check link between bookId and book name
      console.log("ID = " + JSON.parse(check.text)["id"]);
      expect(check2.status).toBe(200);
      expect(JSON.parse(check2.text)["name"]).toBe("test");
    });
    it('call on wrong argument (illegal char)', async () => {
        const res = await request(app).post('/books/create?name=test^z').set(ID).send();
        expect(res.status).toBe(400);
      });
    it('call on wrong argument (invalid len)', async () => {
        const res = await request(app).post('/books/create?name=theNameOfThisBookIsSoLoooooooooooong').set(ID).send();
        expect(res.status).toBe(400);
    });
    it('call on missing argument', async () => {
        const res = await request(app).post('/books/create').set(ID).send();
        expect(res.status).toBe(400);
    });
    /*
    When auth available need to check if book is linked to user
    */
});


describe('DELETE books/delete', () => {
  it('simple call', async () => {
    const res = await request(app).post('/books/create?name=testDelete').set(ID).send();
    expect(res.status).toBe(200);
    const check = await request(app).get('/books/id?bookName=testDelete').set(ID).send(); // check if we can get id of the book
    expect(check.status).toBe(200);
    const check2 = await request(app).delete(`/books/delete?bookId=${JSON.parse(check.text)["id"]}`).set(ID).send(); // check if book can be deleted
    expect(check2.status).toBe(200);
  });
  it('call on missing argument', async () => {
    const check2 = await request(app).delete(`/books/delete`).set(ID).send(); // BookId not specified
    expect(check2.status).toBe(400);
  });
  it('call on not indexed bookId', async () => {
    const check2 = await request(app).delete(`/books/delete?bookId=test3`).set(ID).send();
    expect(check2.status).toBe(200);
  });  
});

describe('POST books/share', () => {
  it('simple call', async () => {
    const res = await request(app).post('/books/create?name=test2').set(ID).send();
    expect(res.status).toBe(200);
    const check = await request(app).get('/books/id?bookName=test2').set(ID).send(); // check if we can get id of the book
    expect(check.status).toBe(200);
    const share = await request(app).post(`/books/share?bookId=${JSON.parse(check.text)["id"]}&userId=23`).set(ID).send();
    expect(share.status).toBe(200);
  });  
  it('call on missing argument (bookId)', async () => {
    const share = await request(app).post(`/books/share?userId=23`).set(ID).send();
    expect(share.status).toBe(400);
  });
  it('call on missing argument (userId)', async () => {
    const res = await request(app).post('/books/create?name=test3').set(ID).send();
    expect(res.status).toBe(200);
    const check = await request(app).get('/books/id?bookName=test3').set(ID).send(); // check if we can get id of the book
    expect(check.status).toBe(200);
    const share = await request(app).post(`/books/share?bookId=${JSON.parse(check.text)["id"]}`).set(ID).send();
    expect(share.status).toBe(400);
  });
  it('call on wrong bookId', async () => {
    const res = await request(app).post('/books/create?name=test4').set(ID).send();
    expect(res.status).toBe(200);
    const check = await request(app).get('/books/id?bookName=test4').set(ID).send(); // check if we can get id of the book
    expect(check.status).toBe(200);
    const share = await request(app).post(`/books/share?bookId=${JSON.parse(check.text)["id"]+1000}&userId=23`).set(ID).send(); // DB is reset before testing -> number of recipe books <1000 
    expect(share.status).toBe(500);
  });
})

describe('POST books/recipe/add', () => {
  it('simple call', async () => {
    const res = await request(app).post('/books/create?name=recipeAddTest').set(ID).send();
    expect(res.status).toBe(200);
    const check = await request(app).get('/books/id?bookName=recipeAddTest').set(ID).send();
    expect(check.status).toBe(200);
    const add = await request(app).post(`/books/recipe/add?bookId=${JSON.parse(check.text)["id"]}&recipeId=21`).set(ID).send();
    expect(add.status).toBe(200);
  });
  it('add to unknown book', async () => {
    const check = await request(app).get('/books/id?bookName=recipeAddTest').set(ID).send();
    expect(check.status).toBe(200);
    const add = await request(app).post(`/books/recipe/add?bookId=${JSON.parse(check.text)["id"]+1000}&recipeId=21`).set(ID).send();
    expect(add.status).toBe(500);
    expect(add.text).toBe("Can't add recipe to given book: no matching id");
  });
  it('call on missing argument (bookId)', async () => {
    const add = await request(app).post(`/books/recipe/add?recipeId=21`).set(ID).send();
    expect(add.status).toBe(400);
    expect(add.text).toBe("You need to specify a bookId and a recipeId");
  });
  it('call on missing argument (recipeId)', async () => {
    const add = await request(app).post(`/books/recipe/add?bookId=1`).set(ID).send();
    expect(add.status).toBe(400);
    expect(add.text).toBe("You need to specify a bookId and a recipeId");
  });
})

describe('GET books/recipes', () => {
  
  it('simple call', async () => {
    const res = await request(app).post('/books/create?name=recipesTest').set(ID).send();
    const check = await request(app).get('/books/id?bookName=recipesTest').set(ID).send();
    expect(check.status).toBe(200);
    expect(res.status).toBe(200);
    const id = JSON.parse(check.text)["id"];

    for (i=1; i<11; i++){
      const add = await request(app).post(`/books/recipe/add?bookId=${id}&recipeId=${i}`).set(ID).send();
      expect(add.status).toBe(200);
    }
    const recipes = await request(app).get(`/books/recipes?bookId=${id}`).set(ID);
    let recipesParsed = JSON.parse(recipes.text);
    expect(recipesParsed["recipes"].length).toBe(10);
    expect(recipesParsed["recipes"]).toStrictEqual(Array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10));
  });
  it('call on unknown bookId', async () => {
    const recipes = await request(app).get(`/books/recipes?bookId=10000`).set(ID);
    expect(recipes.status).toBe(500);
    expect(recipes.text).toBe("Can't get recipes from given book: no matching id");
  });
  it('call on missing bookId', async () => {
    const recipes = await request(app).get(`/books/recipes`).set(ID);
    expect(recipes.status).toBe(400);
    expect(recipes.text).toBe("Need to specify a bookId");
  });
})

describe('GET books/general_information', () => {
  it('simple call', async () => {
    const res = await request(app).post('/books/create?name=recipesGeneralInfos').set(ID).send();
    const check = await request(app).get('/books/id?bookName=recipesGeneralInfos').set(ID).send();
    expect(check.status).toBe(200);
    expect(res.status).toBe(200);
    const id = JSON.parse(check.text)["id"];

    for (i=1; i<11; i++){
      const add = await request(app).post(`/books/recipe/add?bookId=${id}&recipeId=${i}`).set(ID).send();
      expect(add.status).toBe(200);
    }
    const rawInfos = await request(app).get(`/books/general_information?bookId=${id}`).set(ID);
    let bookInfos = JSON.parse(rawInfos.text);
    expect(bookInfos["id"]).toBe(id);
    expect(bookInfos["name"]).toBe("recipesGeneralInfos");
    expect(bookInfos["recipe_count"]).toBe(10);
  });
  it('call on unknown bookId', async () => {
    const res = await request(app).get(`/books/general_information?bookId=10000`).set(ID);
    expect(res.status).toBe(204);
  });
  it('call on missing bookId', async () => {
    const res = await request(app).get(`/books/general_information`).set(ID);
    expect(res.status).toBe(400);
  });

})

describe('DELETE books/share', () => {
  it('simple call', async () => {
    //Create book + share 
    const res = await request(app).post('/books/create?name=shareDelete').set(ID).send();
    expect(res.status).toBe(200);
    const check = await request(app).get('/books/id?bookName=shareDelete').set(ID).send();
    expect(check.status).toBe(200);
    const share = await request(app).post(`/books/share?bookId=${JSON.parse(check.text)["id"]}&userId=1`).set(ID).send();
    expect(share.status).toBe(200);
    //Try to delete share
    const deleteShareLink = await request(app).delete(`/books/share?bookId=${JSON.parse(check.text)["id"]}&userId=1`).set(ID);
    expect(deleteShareLink.status).toBe(200);
  });
  it('call on missing argument (bookId)', async () => {
    const deleteShareLink = await request(app).delete(`/books/share?userId=1`).set(ID);
    expect(deleteShareLink.status).toBe(400);
  });
  it('call on missing argument (userId)', async () => {
    const deleteShareLink = await request(app).delete(`/books/share?bookId=1`).set(ID);
    expect(deleteShareLink.status).toBe(400);
  });
})

describe('GET books/id', () => {
  it('call on unknown bookName', async () => {
    const res = await request(app).get(`/books/id?bookName=unknownBookName`).set(ID);
    expect(res.status).toBe(204);
  });
  it('call on undefined bookName', async () => {
    const res = await request(app).get(`/books/id`).set(ID);
    expect(res.status).toBe(400);
  });
})