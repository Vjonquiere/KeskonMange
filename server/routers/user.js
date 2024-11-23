const express = require('express');
const router = express.Router();
const database = require('../module/database');
const conn = database.conn;


let verification = {}

function generateVerificationCode(){
    let code = ""
    const chars = "0123456789"
    const charactersLength = chars.length;
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
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    const usernameRegex = /^[a-zA-Z0-9_-]{3,16}$/;
    if (!emailRegex.test(req.query.email) || !usernameRegex.test(req.query.username)){
        res.status(405).send("Email or username is not valid");
        return;
    }
    // Need username + email regex
    const emailUnique = await conn.query("SELECT COUNT(id) FROM users WHERE email = ?;", [req.query.email]);
    const usernameUnique = await conn.query("SELECT COUNT(id) FROM users WHERE username = ?;", [req.query.username]);
    if (Array.from(emailUnique)[0]['COUNT(id)'] > 0){
        res.status(405).send("Email is already used, try connect instead");
        return;
    }
    if (Array.from(usernameUnique)[0]['COUNT(id)'] > 0){
        res.status(405).send("This username is taken by another user, find a new one!");
        return;
    }
    const verificationCode = generateVerificationCode();
    await conn.query("INSERT INTO verify VALUES (?, ?);", [req.query.email, verificationCode]);
    await conn.query("INSERT INTO users VALUES (NULL, ?, ?, NULL);", [req.query.email, req.query.username]);
    res.sendStatus(200);
})

router.post('/verify', async (req, res) => {
    if (req.query.email === undefined || req.query.code === undefined || isNaN(Number(req.query.code))){
        res.status(405).send("Need to specify an email and a verification code");
        return;
    }
    const user = await conn.query("SELECT email FROM verify WHERE email = ? AND code = ?;", [req.query.email, req.query.code]);
    const arrayUser = Array.from(user);
    if (arrayUser.length > 0 && arrayUser[0]["email"] == req.query.email){
        let date = new Date();
        let formattedDate = date.toISOString().split('T')[0];
        await conn.query("UPDATE users SET verified = ? WHERE email = ?;", [formattedDate, req.query.email]);
        await conn.query("DELETE FROM verify WHERE email = ?;", [req.query.email]);
        verification[req.query.email] = undefined;
        res.status(200).send("User has been created");
        return;
    }
    res.sendStatus(204);
})

router.closeServer = () => {
    console.log("Users Closed");
  };
  
  
  module.exports = router;