const request = require("supertest");
const app = require("../server");

afterAll(async () => {
  app.closeServer();
});

describe("GET unknown route", () => {
  it("simple call", async () => {
    const res = await request(app).get("/unknownRoute");
    expect(res.status).toBe(404);
  });
});

describe("GET server/alive", () => {
  it("simple call", async () => {
    const res = await request(app).get("/server/alive");
    expect(res.status).toBe(200);
  });
});
