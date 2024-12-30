const crypto = require('crypto');
var database = require('./database');
const conn = database.conn;

/*async function checkApiKey(req, res, next) {
    const apiKey = req.headers['x-api-key'];
    const username = req.headers['username'];
    if (!apiKey) {
        return res.status(401).send("No API key found");
    }
    const client = await conn.query("SELECT COUNT(username) FROM ")
    if (!client) {
        return res.status(403).json({ error: 'Clé API invalide' });
    }
    req.client = client;
    next();
}*/

function generateApiKey() {
    return crypto.randomBytes(30).toString('hex');
}

function getApiKeyHash(token){
    return crypto.createHash('sha256').update(token).digest('hex');
}

async function generateAuthToken(email){
    const token = generateApiKey();
    const tokenSHA256 = crypto.createHash('sha256').update(token).digest('hex');
    const date = new Date();
    let formattedBeginDate = date.toISOString().split('T')[0];
    date.setDate(date.getDate() + 30);
    let formattedExpireDate = date.toISOString().split('T')[0];
    let userId = await conn.query("SELECT * FROM users WHERE email = ?;", [email]);
    await conn.query("INSERT INTO authentication VALUES (?,?,?,?,0);", [tokenSHA256, userId[0].id, formattedBeginDate, formattedExpireDate]);
    return token;
}

module.exports = {
    generateAuthToken : generateAuthToken,
    getApiKeyHash : getApiKeyHash
};