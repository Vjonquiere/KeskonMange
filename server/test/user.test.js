const request = require('supertest');
const app = require('../server');
const mariadb = require('mariadb');
const utils = require('./utils');
const login = require('./login');

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
    /*await conn.query("DELETE FROM users WHERE 1=1;");
    await conn.query("DELETE FROM verify WHERE 1=1;");*/
});

afterAll(async () => {
    app.closeServer();
    utils.end_connexion();
    conn.end();
});

describe('POST user/create', () => {
    it('simple call', async () => {
      const res = await request(app).post(`/user/create?email=${process.env.POP3_ADDRESS}&username=test`);
      expect(res.status).toBe(200);
    });
    it('call with missing parameter (email)', async () => {
        const res = await request(app).post('/user/create?username=test');
        expect(res.status).toBe(405);
    });
    it('call with missing parameter (username)', async () => {
        const res = await request(app).post(`/user/create?email=${process.env.POP3_ADDRESS}`);
        expect(res.status).toBe(405);
    });
    it('call on wrong email', async () => {
        const res = await request(app).post('/user/create?email=test%40test&username=test');
        expect(res.status).toBe(405);
    });
    it('call on wrong username (invalid character)', async () => {
        const res = await request(app).post('/user/create?email=test%40test.com&username=test@1');
        expect(res.status).toBe(405);
    });
    it('call on wrong username (invalid length)', async () => {
        const res = await request(app).post('/user/create?email=test%40test.com&username=test1234567891011');
        expect(res.status).toBe(405);
    });
    it('email already used', async () => {
        const res = await request(app).post(`/user/create?email=${process.env.POP3_ADDRESS}&username=test2`);
        expect(res.status).toBe(405);
        expect(res.text).toBe("Email is already used, try connect instead");
    });
    it('username already used', async () => {
        const res = await request(app).post(`/user/create?email=${process.env.POP3_ADDRESS}m&username=test`);
        expect(res.status).toBe(405);
        expect(res.text).toBe("This username is taken by another user, find a new one!");
    });
})

describe('POST user/verify', () => {
    it('simple call', async () => {
        const verificationCode = Array.from(await conn.query("SELECT code FROM verify WHERE email = ?;", [process.env.POP3_ADDRESS]))[0]["code"]; // User previously created
        console.log(verificationCode);
        const res = await request(app).post(`/user/verify?email=${process.env.POP3_ADDRESS}&code=${verificationCode}`);
        expect(res.status).toBe(200);
    });
    it('call on unknown values', async () => {
        const res = await request(app).post(`/user/verify?email=unknown%40test.com&code=0000`);
        expect(res.status).toBe(204);
    });
    it('call on missing parameter (email)', async () => {
        const res = await request(app).post(`/user/verify?code=0000`);
        expect(res.status).toBe(405);
    });
    it('call on missing parameter (code)', async () => {
        const res = await request(app).post(`/user/verify?email=unknown%40test.com`);
        expect(res.status).toBe(405);
    });
})

describe('GET user/availableUsername', () => {
    it('simple call', async () => {
        const res = await request(app).get(`/user/availableUsername?username=IsAvailable`);
        expect(res.status).toBe(200);
    });
    it('call on already used username', async () => {
        const res = await request(app).get(`/user/availableUsername?username=test`);
        expect(res.status).toBe(405);
    });
    it('call on missing argument (username)', async () => {
        const res = await request(app).get(`/user/availableUsername`);
        expect(res.status).toBe(405);
    });
})

describe('GET user/availableEmail', () => {
    it('simple call', async () => {
        const res = await request(app).get(`/user/availableEmail?email=IsAvailable@mail.com`);
        expect(res.status).toBe(200);
    });
    it('call on already used email', async () => {
        const res = await request(app).get(`/user/availableEmail?email=${process.env.POP3_ADDRESS}`);
        expect(res.status).toBe(405);
    });
    it('call on missing argument (email)', async () => {
        const res = await request(app).get(`/user/availableEmail`);
        expect(res.status).toBe(405);
    });
})

describe('GET user/infos', () => {
    it('simple call', async () => {
        const res = await request(app).get(`/user/infos`).set(ID).send();
        expect(res.text).toBe(JSON.stringify({ email: 'fake@email.com', username: 'USER'}));
        expect(res.status).toBe(200);
    });
})