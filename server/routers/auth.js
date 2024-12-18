const express = require('express');
const router = express.Router();
var bodyParser = require('body-parser');
var database = require('../module/database');
const crypto = require('crypto');
const conn = database.conn;

var waitingAuths = {}

router.use(bodyParser.json());
router.use(
  bodyParser.urlencoded({
    extended: true,
  }),
);

function generateVerificationCode(){
    let code = ""
    const chars = "0123456789"
    const charactersLength = chars.length;
    for (i=0; i<4; i++){
        code += chars.charAt(Math.floor(Math.random() * charactersLength));
    }
    return code;
}

function generateApiKey() {
    return crypto.randomBytes(30).toString('hex');
}

async function checkApiKey(req, res, next) {
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
}


router.post('/signin', async (req, res) => {
    if (req.query.email === undefined ){
        res.status(405).send("You must specify the email you want to log in");
        return
    }
    if (req.query.code === undefined){ // Create a code and send to user
        const userExists = Array.from(await conn.query("SELECT COUNT(id) FROM users WHERE email = ?;", [req.query.email]));
        if (userExists.length > 0 && Number(userExists[0]['COUNT(id)']) == 1){
            waitingAuths[req.query.email] = generateVerificationCode();
            console.log(waitingAuths[req.query.email]);
            res.sendStatus(200);
        } else {
            res.status(404).send("No user found with this mail");
            return;
        }
    } else {
        if (waitingAuths[req.query.email] == req.query.code){
            waitingAuths[req.query.email] = undefined;
            const token = generateApiKey();
            const tokenSHA256 = crypto.createHash('sha256').update(token).digest('hex');
            console.log("token = " + token + " | tokenSHA256 = " + tokenSHA256);
            const date = new Date();
            let formattedBeginDate = date.toISOString().split('T')[0];
            date.setDate(date.getDate() + 30);
            let formattedExpireDate = date.toISOString().split('T')[0];
            let userId = await conn.query("SELECT * FROM users WHERE email = ?;", [req.query.email]);
            await conn.query("INSERT INTO authentication VALUES (?,?,?,?,0);", [tokenSHA256, userId[0].id, formattedBeginDate, formattedExpireDate]);
            res.status(200).send(JSON.stringify({"token":token}));
            return;
        }
        res.sendStatus(404);
    }
    
})

router.post('/signin', async (req, res) => {
    if (req.query.email === undefined ){
        res.status(405).send("You must specify the email you want to log in");
        return
    }
    const userExists = Array.from(await conn.query("SELECT COUNT(id) FROM users WHERE email = ?;", [req.query.email]));
    if (userExists.length > 0 && Number(userExists[0]['COUNT(id)']) == 1){
        waitingAuths[req.query.email] = generateVerificationCode();
        console.log(waitingAuths[req.query.email]);
        res.sendStatus(200);
    } else {
        res.status(404).send("No user found with this mail");
        return;
    }
})

router.closeServer = () => {
    console.log("Auth Closed");
};


module.exports = router;