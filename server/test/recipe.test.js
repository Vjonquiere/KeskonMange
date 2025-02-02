const request = require('supertest');
const app = require('../server');
const mariadb = require('mariadb');
const login = require('./login');
const utils = require('./utils');

const conn =  mariadb.createPool({
  host: process.env.DATABASE_HOST, 
  user: process.env.DATABASE_USER,
  password: process.env.DATABASE_PASSWORD,
  database: process.env.DATABASE_NAME,
  dateStrings: true
});

let ID;

beforeAll(async () => {
  await utils.clearDatabase();
  ID = await login.getCredentials()
  //await conn.query("DELETE FROM recipes WHERE 1=1;");
  await conn.query("INSERT INTO recipes VALUES (null, 'test_recipe1', 'test', 0, 0, 1, true, true, false, false, false, false, false, 0, 0);");
  await conn.query("INSERT INTO recipes VALUES (null, 'test_recipe2', 'test', 0, 0, 1, true, true, false, false, false, false, false, 0, 0);");
  await conn.query("INSERT INTO recipes VALUES (null, 'test_recipe3', 'test', 0, 0, 1, true, true, false, false, false, false, false, 0, 0);");
  await request(app).post('/ingredient/add').set(ID).send({"name": "Pates", "type": "grocerie"});
  await request(app).post('/ingredient/add').set(ID).send({"name": "Viande hachee", "type": "meat"});
  await request(app).post('/ingredient/add').set(ID).send({"name": "Sauce tomate", "type": "grocerie"});
});

afterAll(async () => {
  conn.end();
  utils.end_connexion();
  app.closeServer();
});



describe('GET recipe/:id', () => {
  it('call on undifined recipe_id', async () => {
    const res = await request(app).get('/recipe/PO').set(ID).send();
    expect(res.status).toBe(405);
    expect(res.text).toBe("undifined recipe_id");
  });
  it('call on good parameters with last recipe', async () => {
    const last_recipe = await request(app).get('/recipe/last');
    console.log(last_recipe.body["id"]);
    const res = await request(app).get('/recipe/'+last_recipe.body["id"]).set(ID).send();
    expect(res.status).toBe(200);
  })
})

describe('POST recipe/add', () => {
  it('call on valid arguments', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":[{"name":"Pates", "qte":200, "unit":"g", "type":"grocerie" }, {"name":"Viande hachee", "qte":100, "unit":"g", "type":"meat" }, {"name":"Sauce tomate", "qte":100, "unit":"g", "type":"grocerie" }], "preparation_time":10, "rest_time":0, "cook_time":10, "sweet":false, "salty":true, "title":"Pates bolognaise", "type":"plat", "difficulty":1, "cost":1, "portions":3});
    expect(res.status).toBe(200);
  });
  /*it('call on unknown ingredient', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":[{"name":"Pates", "qte":200, "unit":"g", "type":"grocerie" }, {"name":"Viande hachee", "qte":100, "unit":"g", "type":"meat" }, {"name":"Sauce tomate", "qte":100, "unit":"g", "type":"grocerie" }, {"name":"Fromage", "qte":100, "unit":"g", "type":"grocerie" }], "preparation_time":10, "rest_time":0, "cook_time":10, "sweet":false, "salty":true, "title":"Pates bolognaise", "type":"plat", "difficulty":1, "cost":1, "portions":3});
    expect(res.status).toBe(400);
    expect(res.text).toBe("Fromage is an unknown ingredient")
  });*/
  it('call on missing argument (preparation_time)', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":[{"name":"Pates", "qte":200, "unit":"g", "type":"grocerie" }, {"name":"Viande hachee", "qte":100, "unit":"g", "type":"meat" }, {"name":"Sauce tomate", "qte":100, "unit":"g", "type":"grocerie" }], "rest_time":0, "cook_time":10, "sweet":false, "salty":true, "title":"Pates bolognaise", "type":"plat", "difficulty":1, "cost":1, "portions":3});
    expect(res.status).toBe(400);
    expect(res.text).toBe("Please check if all arguments are valid");
  });
  it('call on missing argument (rest_time)', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":[{"name":"Pates", "qte":200, "unit":"g", "type":"grocerie" }, {"name":"Viande hachee", "qte":100, "unit":"g", "type":"meat" }, {"name":"Sauce tomate", "qte":100, "unit":"g", "type":"grocerie" }], "preparation_time":10, "cook_time":10, "sweet":false, "salty":true, "title":"Pates bolognaise", "type":"plat", "difficulty":1, "cost":1, "portions":3});
    expect(res.status).toBe(400);
    expect(res.text).toBe("Please check if all arguments are valid");
  });
  it('call on missing argument (cook_time)', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":[{"name":"Pates", "qte":200, "unit":"g", "type":"grocerie" }, {"name":"Viande hachee", "qte":100, "unit":"g", "type":"meat" }, {"name":"Sauce tomate", "qte":100, "unit":"g", "type":"grocerie" }], "preparation_time":10, "rest_time":0, "sweet":false, "salty":true, "title":"Pates bolognaise", "type":"plat", "difficulty":1, "cost":1, "portions":3});
    expect(res.status).toBe(400);
    expect(res.text).toBe("Please check if all arguments are valid");
  });
  it('call on missing argument (sweet)', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":[{"name":"Pates", "qte":200, "unit":"g", "type":"grocerie" }, {"name":"Viande hachee", "qte":100, "unit":"g", "type":"meat" }, {"name":"Sauce tomate", "qte":100, "unit":"g", "type":"grocerie" }], "preparation_time":10, "rest_time":0, "cook_time":10, "salty":true, "title":"Pates bolognaise", "type":"plat", "difficulty":1, "cost":1, "portions":3});
    expect(res.status).toBe(400);
    expect(res.text).toBe("Please check if all arguments are valid");
  });
  it('call on missing argument (salty)', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":[{"name":"Pates", "qte":200, "unit":"g", "type":"grocerie" }, {"name":"Viande hachee", "qte":100, "unit":"g", "type":"meat" }, {"name":"Sauce tomate", "qte":100, "unit":"g", "type":"grocerie" }], "preparation_time":10, "rest_time":0, "cook_time":10, "sweet":false, "title":"Pates bolognaise", "type":"plat", "difficulty":1, "cost":1, "portions":3});
    expect(res.status).toBe(400);
    expect(res.text).toBe("Please check if all arguments are valid");
  });
  it('call on missing argument (title)', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":[{"name":"Pates", "qte":200, "unit":"g", "type":"grocerie" }, {"name":"Viande hachee", "qte":100, "unit":"g", "type":"meat" }, {"name":"Sauce tomate", "qte":100, "unit":"g", "type":"grocerie" }], "preparation_time":10, "rest_time":0, "cook_time":10, "sweet":false, "salty":true, "type":"plat", "difficulty":1, "cost":1, "portions":3});
    expect(res.status).toBe(400);
    expect(res.text).toBe("Please check if all arguments are valid");
  });
  it('call on missing argument (type)', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":[{"name":"Pates", "qte":200, "unit":"g", "type":"grocerie" }, {"name":"Viande hachee", "qte":100, "unit":"g", "type":"meat" }, {"name":"Sauce tomate", "qte":100, "unit":"g", "type":"grocerie" }], "preparation_time":10, "rest_time":0, "cook_time":10, "sweet":false, "salty":true, "title":"Pates bolognaise", "difficulty":1, "cost":1, "portions":3});
    expect(res.status).toBe(400);
    expect(res.text).toBe("Please check if all arguments are valid");
  });
  it('call on missing argument (difficulty)', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":[{"name":"Pates", "qte":200, "unit":"g", "type":"grocerie" }, {"name":"Viande hachee", "qte":100, "unit":"g", "type":"meat" }, {"name":"Sauce tomate", "qte":100, "unit":"g", "type":"grocerie" }], "preparation_time":10, "rest_time":0, "cook_time":10, "sweet":false, "salty":true, "title":"Pates bolognaise", "type":"plat", "cost":1, "portions":3});
    expect(res.status).toBe(400);
    expect(res.text).toBe("Please check if all arguments are valid");
  });
  it('call on missing argument (cost)', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":[{"name":"Pates", "qte":200, "unit":"g", "type":"grocerie" }, {"name":"Viande hachee", "qte":100, "unit":"g", "type":"meat" }, {"name":"Sauce tomate", "qte":100, "unit":"g", "type":"grocerie" }], "preparation_time":10, "rest_time":0, "cook_time":10, "sweet":false, "salty":true, "title":"Pates bolognaise", "type":"plat", "difficulty":1, "portions":3});
    expect(res.status).toBe(400);
    expect(res.text).toBe("Please check if all arguments are valid");
  });
  it('call on missing argument (portions)', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":[{"name":"Pates", "qte":200, "unit":"g", "type":"grocerie" }, {"name":"Viande hachee", "qte":100, "unit":"g", "type":"meat" }, {"name":"Sauce tomate", "qte":100, "unit":"g", "type":"grocerie" }], "preparation_time":10, "rest_time":0, "cook_time":10, "sweet":false, "salty":true, "title":"Pates bolognaise", "type":"plat", "difficulty":1, "cost":1});
    expect(res.status).toBe(400);
    expect(res.text).toBe("Please check if all arguments are valid");
  });
  it('call on missing argument (ingredients)', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"preparation_time":10, "rest_time":0, "cook_time":10, "sweet":false, "salty":true, "title":"Pates bolognaise", "type":"plat", "difficulty":1, "cost":1, "portions":3});
    expect(res.status).toBe(400);
    expect(res.text).toBe("Please check if all arguments are valid");
  });
  it('call on invalid argument (ingredients !array)', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":{"name":"Pates", "qte":200, "unit":"g", "type":"grocerie" }, "preparation_time":10, "rest_time":0, "cook_time":10, "sweet":false, "salty":true, "title":"Pates bolognaise", "type":"plat", "difficulty":1, "cost":1, "portions":3});
    expect(res.status).toBe(400);
    expect(res.text).toBe("Ingredient list should be an array");
  });
  /*it('call on invalid argument (ingredient with unknown unit)', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":[{"name":"Pates", "qte":200, "unit":"l", "type":"grocerie" }, {"name":"Viande hachee", "qte":100, "unit":"g", "type":"meat" }, {"name":"Sauce tomate", "qte":100, "unit":"g", "type":"grocerie" }], "preparation_time":10, "rest_time":0, "cook_time":10, "sweet":false, "salty":true, "title":"Pates bolognaise", "type":"plat", "difficulty":1, "cost":1, "portions":3});
    expect(res.status).toBe(400);
    expect(res.text).toBe("Ingredient Pates has an unknown unit");
  });*/
  it('call on invalid argument (rest_time Nan)', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":[{"name":"Pates", "qte":200, "unit":"g", "type":"grocerie" }, {"name":"Viande hachee", "qte":100, "unit":"g", "type":"meat" }, {"name":"Sauce tomate", "qte":100, "unit":"g", "type":"grocerie" }], "preparation_time":10, "rest_time":"A", "cook_time":10, "sweet":false, "salty":true, "title":"Pates bolognaise", "type":"plat", "difficulty":1, "cost":1, "portions":3});
    expect(res.status).toBe(400);
    expect(res.text).toBe("Time must be a number");
  });
  it('call on invalid argument (salty !Bool)', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":[{"name":"Pates", "qte":200, "unit":"g", "type":"grocerie" }, {"name":"Viande hachee", "qte":100, "unit":"g", "type":"meat" }, {"name":"Sauce tomate", "qte":100, "unit":"g", "type":"grocerie" }], "preparation_time":10, "rest_time":0, "cook_time":10, "sweet":"False", "salty":true, "title":"Pates bolognaise", "type":"plat", "difficulty":1, "cost":1, "portions":3});
    expect(res.status).toBe(400);
    expect(res.text).toBe("False can not be turned into a Boolean");
  });
  it('call on invalid argument (difficulty Nan)', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":[{"name":"Pates", "qte":200, "unit":"g", "type":"grocerie" }, {"name":"Viande hachee", "qte":100, "unit":"g", "type":"meat" }, {"name":"Sauce tomate", "qte":100, "unit":"g", "type":"grocerie" }], "preparation_time":10, "rest_time":0, "cook_time":10, "sweet":false, "salty":true, "title":"Pates bolognaise", "type":"plat", "difficulty":"Nan", "cost":1, "portions":3});
    expect(res.status).toBe(400);
    expect(res.text).toBe("Difficulty must be a number");
  });
  it('call on invalid argument (portions Nan)', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":[{"name":"Pates", "qte":200, "unit":"g", "type":"grocerie" }, {"name":"Viande hachee", "qte":100, "unit":"g", "type":"meat" }, {"name":"Sauce tomate", "qte":100, "unit":"g", "type":"grocerie" }], "preparation_time":10, "rest_time":0, "cook_time":10, "sweet":false, "salty":true, "title":"Pates bolognaise", "type":"plat", "difficulty":1, "cost":1, "portions":"Nan"});
    expect(res.status).toBe(400);
    expect(res.text).toBe("Portions must be a number");
  });
  it('call on invalid argument (cost Nan)', async () => {
    const res = await request(app).post('/recipe/add').set(ID).send({"ingredients":[{"name":"Pates", "qte":200, "unit":"g", "type":"grocerie" }, {"name":"Viande hachee", "qte":100, "unit":"g", "type":"meat" }, {"name":"Sauce tomate", "qte":100, "unit":"g", "type":"grocerie" }], "preparation_time":10, "rest_time":0, "cook_time":10, "sweet":false, "salty":true, "title":"Pates bolognaise", "type":"plat", "difficulty":1, "cost":"lowcost", "portions":3});
    expect(res.status).toBe(400);
    expect(res.text).toBe("Cost must be a number");
  });
})
