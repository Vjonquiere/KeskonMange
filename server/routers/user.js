const express = require('express');
const router = express.Router();
const mariadb = require('mariadb');

const conn =  mariadb.createPool({
    host: process.env.DATABASE_HOST, 
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE_NAME
  });

router.use(bodyParser.json());
router.use(
bodyParser.urlencoded({
    extended: true,
}),
);

let verification = {}

function generateVerificationCode(){
    let code = ""
    const chars = "0123456789"
    const charactersLength = characters.length;
    for (i=0; i<4; i++){
        code += chars.charAt(Math.floor(Math.random() * charactersLength));
    }
    return code;
}

router.post('/create', async (req, res) => {
    if (req.query.email === undefined || req.query.username === undefined){
        res.status(405).send("An email and a username are required to create an account");
        return;
    }
    // Need username + email regex
    const emailUnique = await conn.query("SELECT * FROM users WHERE email = ?;", [req.query.email]);
    const usernameUnique = await conn.query("SELECT * FROM users WHERE username = ?;", [req.query.username]);
    if (!emailUnique){
        res.status(405).send("Email is already used, try connect instead");
        return;
    }
    if (!usernameUnique){
        res.status(405).send("This username is taken by another user, find a new one!");
        return;
    }
    const verificationCode = generateVerificationCode();
    console.log(verificationCode);
    verification[req.query.email] = verificationCode;
    await conn.query("INSERT INTO users VALUES (NULL, ?, ?, NULL);", [req.query.email, req.query.username]);
})

router.post('/verify', async (req, res) => {
    if (req.query.email === undefined || req.query.code === undefined || isNaN(Number(req.query.code))){
        res.status(405).send("Need to specify an email and a verification code");
        return;
    }
    if (!(verification[req.query.email] === undefined) && verification[req.query.email] == Number(req.query.code)){
        let date = new Date();
        let formattedDate = date.toISOString().split('T')[0];
        await conn.query("UPDATE users SET verified = ? WHERE email = ?;", [formattedDate, req.query.email]);
        verification[req.query.email] = undefined;
        res.status(200).send("User has been created");
        return;
    }
    res.sendStatus(204);
})

router.closeServer = () => {
    conn.end()
    console.log("Recipes Closed");
  };
  
  
  module.exports = router;