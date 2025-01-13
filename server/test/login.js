const token = require('../module/token');
const conn = require('../module/database').conn;
let API_KEY = undefined;
const username = "USER";
const email = "fake@email.com"

async function getCredentials(){
    if (API_KEY === undefined){
        await conn.query("INSERT INTO users VALUES (NULL, ?, ?, '2025-01-06');", [email, username]);
        API_KEY = await token.generateAuthToken(email);
    }
    return {"username": username, "x-api-key":API_KEY};
}

function setApiKey(api_key){
    API_KEY = api_key;
}

module.exports = {
    getCredentials: getCredentials,
    setApiKey : setApiKey
}