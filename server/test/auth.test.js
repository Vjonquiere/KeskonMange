const Pop3Command = require('node-pop3');
const request = require('supertest');
const app = require('../server');
const simpleParser = require('mailparser').simpleParser;
const database = require('../module/database');
const conn = database.conn;
const utils = require('./utils');


const pop3 = new Pop3Command({
    user: process.env.POP3_ADDRESS,
    password: process.env.POP3_PASSWORD,
    host: process.env.POP3_HOST,
    mailparser: true
  });

function sleep(ms) {
return new Promise((resolve) => {
    setTimeout(resolve, ms);
});
}

beforeAll(async () => {
  await utils.clearDatabase();
  //await conn.query("DELETE FROM users WHERE 1=1;");
  await conn.query("INSERT INTO users VALUES (NULL, ?, 'test', '2025-01-06');", [process.env.POP3_ADDRESS]);
});

afterAll(async () => {
    app.closeServer();
    utils.end_connexion();
});

connexionToken = undefined;

describe('POST auth/signin', () => {
  it('simple call', async () => {
    const res = await request(app).post(`/auth/signin?email=${process.env.POP3_ADDRESS}&lang=debug`).send();
    expect(res.status).toBe(200); // Trying to init a new connexion
    await sleep(1500); // Sleep to wait for new mail
    const list = Array.from(await pop3.UIDL());
    const str = await pop3.RETR(list.length);     
    const parsedEmail = await simpleParser(str);
    const res2 = await request(app).post(`/auth/signin?email=${process.env.POP3_ADDRESS}&lang=debug&code=${parsedEmail.subject}`).send();
    expect(res2.status).toBe(200);
    connexionToken = JSON.parse(res2.text).token;
    pop3.QUIT();
  });
  it('call on missing argument (email)', async () => {
    const res = await request(app).post(`/auth/signin?lang=debug`).send();
    expect(res.status).toBe(405);
    expect(res.text).toBe("You must specify the email you want to log in");
  });
  it('call on invalid email (no account created with it)', async () => {
    const res = await request(app).post(`/auth/signin?email=test120%40test.com&lang=debug`).send();
    expect(res.status).toBe(404);
    expect(res.text).toBe("No user found with this mail");
  });
  it('call on invalid data (no matching between email and code)', async () => {
    const res = await request(app).post(`/auth/signin?email=test120%40test.com&lang=debug&code=2131`).send();
    expect(res.status).toBe(404);
  });

});

describe('GET auth/test', () => {
    it('simple call', async () => {
        const res = await request(app).post(`/auth/test?email=${process.env.POP3_ADDRESS}&api_key=${connexionToken}`).send();
        expect(res.status).toBe(200);
    });
    it('call on missing argument (email)', async () => {
        const res = await request(app).post(`/auth/test?&api_key=${connexionToken}`).send();
        expect(res.status).toBe(405);
    });
    it('call on missing argument (api_key)', async () => {
        const res = await request(app).post(`/auth/signin?api_key=${connexionToken}`).send();
        expect(res.status).toBe(405);
    });
    // TODO: need to add test for expired tokens 
});