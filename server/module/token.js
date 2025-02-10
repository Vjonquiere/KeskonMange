const crypto = require("crypto");
var database = require("./database");
const conn = database.conn;
const redis = require("redis");
const client = redis.createClient();
client.connect().then(() => console.log("Redis connected"));

async function checkApiKey(req, res, next) {
  const apiKey = req.headers["x-api-key"];
  const username = req.headers["username"];

  if (!apiKey) {
    return res.status(401).json({ error: "No API key provided" });
  }

  const apiKeyHash = crypto.createHash("sha256").update(apiKey).digest("hex");

  try {
    const data = await client.get(apiKeyHash);
    if (data) {
      const userInfo = JSON.parse(data);
      if (userInfo.username !== username) {
        return res
          .status(403)
          .json({ error: "Invalid username for this API key" });
      }
      req.user = userInfo;
      return next();
    }
    const [userIdResult] = await conn.query(
      "SELECT id FROM users WHERE username = ?;",
      [username],
    );
    if (!userIdResult || userIdResult.length === 0) {
      return res.status(403).json({ error: "User not found" });
    }

    const userId = userIdResult.id;

    const [authResult] = await conn.query(
      "SELECT userId, expire FROM authentication WHERE token = ? AND userId = ?;",
      [apiKeyHash, userId],
    );
    if (!authResult || authResult.length === 0) {
      return res.status(403).json({ error: "Invalid or expired API key" });
    }

    await cacheToken(apiKeyHash, { username, userId }, 3600); // Keep token in cache for 1h

    req.user = { username, userId };
    next();
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal server error" });
  }
}

async function cacheToken(tokenHash, userInfo, expireInSeconds) {
  await client.set(tokenHash, JSON.stringify(userInfo), {
    EX: expireInSeconds,
  });
}

function generateApiKey() {
  return crypto.randomBytes(30).toString("hex");
}

function getApiKeyHash(token) {
  return crypto.createHash("sha256").update(token).digest("hex");
}

async function generateAuthToken(email) {
  const token = generateApiKey();
  const tokenSHA256 = crypto.createHash("sha256").update(token).digest("hex");
  const date = new Date();
  let formattedBeginDate = date.toISOString().split("T")[0];
  date.setDate(date.getDate() + 30);
  let formattedExpireDate = date.toISOString().split("T")[0];
  let userId = await conn.query("SELECT * FROM users WHERE email = ?;", [
    email,
  ]);
  await conn.query("INSERT INTO authentication VALUES (?,?,?,?,0);", [
    tokenSHA256,
    userId[0].id,
    formattedBeginDate,
    formattedExpireDate,
  ]);
  return token;
}

function close() {
  client.QUIT();
}

module.exports = {
  generateAuthToken: generateAuthToken,
  getApiKeyHash: getApiKeyHash,
  checkApiKey: checkApiKey,
  close: close,
};
