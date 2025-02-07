const express = require('express');
const router = express.Router();
const database = require('../module/database');
const conn = database.conn;
const mailer = require('../module/mailer');
const token = require('../module/token')
const constants = require('../module/constants');
const needAuth = token.checkApiKey;

const ALLERGEN_NUMBER = constants.ALLERGEN_NUMBER; 


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


/**
 * @api [get] /user/availableUsername
 * tags : 
 *  - User
 * description: "Check if the given username is free an can be used"
 * parameters:
 * - name: username
 *   in: query
 *   description: The username you wan't to check for availability
 *   required: true
 *   type: string
 *
 * responses:
 *   "200":
 *     description: "The username is free"
 *   "405":
 *      description: "The username is not free"
 */
router.get('/availableUsername', async (req, res) =>{
    if (req.query.username === undefined){
        res.status(405).send("A username is required to create an account");
        return;
    }
    const usernameUnique = await conn.query("SELECT COUNT(id) FROM users WHERE username = ?;", [req.query.username]);
    if (Array.from(usernameUnique)[0]['COUNT(id)'] > 0){
        res.status(405).send("This username is taken by another user, find a new one!");
        return;
    }
    res.sendStatus(200);
})


/**
 * @api [get] /user/availableEmail
 * tags : 
 *  - User
 * description: "Check if the given email is free an can be used"
 * parameters:
 * - name: email
 *   in: query
 *   description: The email you wan't to check for availability
 *   required: true
 *   type: string
 *
 * responses:
 *   "200":
 *     description: "The email is not taken"
 *   "405":
 *      description: "The username is already used"
 */
router.get('/availableEmail', async (req, res) =>{
    if (req.query.email === undefined){
        res.status(405).send("An email is required to create an account");
        return;
    }
    const emailUnique = await conn.query("SELECT COUNT(id) FROM users WHERE email = ?;", [req.query.email]);
    if (Array.from(emailUnique)[0]['COUNT(id)'] > 0){
        res.status(405).send("Email is already used, try connect instead");
        return;
    }
    res.sendStatus(200);
})


/**
 * @api [post] /user/create
 * tags : 
 *  - User
 * description: "Create a new user"
 * parameters:
 * - name: email
 *   in: query
 *   description: The email of the account
 *   required: true
 *   type: string
* - name: username
 *   in: query
 *   description: The username of the account
 *   required: true
 *   type: string
 *
 * responses:
 *   "200":
 *     description: "The user has been added"
 *   "405":
 *      description: "The user can't be added (see error string)"
 */
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
    await mailer.sendVerificationCode(req.query.email, req.query.username, verificationCode, "en");
    res.sendStatus(200);
})


/**
 * @api [post] /user/verify
 * tags : 
 *  - User
 * description: "Verify an account, create an API key and send it to user"
 * parameters:
 * - name: email
 *   in: query
 *   description: The email of the account
 *   required: true
 *   type: string
* - name: code
 *   in: query
 *   description: The code sent by mail
 *   required: true
 *   type: number
 *
 * responses:
 *   "200":
 *     description: "The user has been verified and created (api key sent)"
 *   "204":
 *     description: "No matching data"
 *   "405":
 *      description: "At least one argument is missing"
 */
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
        const userToken = await token.generateAuthToken(req.query.email);
        res.status(200).send(JSON.stringify({"token":userToken}));
        return;
    }
    res.sendStatus(204);
})

/**
 * @api [post] /user/allergens
 * tags : 
 *  - User
 * description: "Check or change the allergens of an user"
 * parameters:
 * - name: email
 *   in: query
 *   description: The email of the account
 *   required: true
 *   type: string
 * responses:
 *   "200":
 *     description: "Allergens updated or list sent"
 *   "405":
 *      description: "Email is needed"
 */ //TODO: complete doc
router.post('/allergens', needAuth, async (req, res) => {
    if (req.query.email === undefined){
        res.status(405).send("Can't set allergens on an unknown account");
        return;
    }
    if (req.body.hasOwnProperty("allergens")){
        const allergens = Array.from(req.body.allergens);
        for (let i=0; i<allergens.length; i++){
            if (!isNaN(Number(allergens[i])) && allergens[i] < ALLERGEN_NUMBER){
                conn.query("INSERT INTO allergens VALUES (?, ?);", [req.user.userId, allergens[i]])
            }
        }
        res.sendStatus(200);
        return;
    } else {
        const allergens = await conn.query("SELECT allergenId AS allergen FROM allergens JOIN users on allergens.userId = users.id WHERE users.email = ?;", [req.query.email]);
        if (allergens.length > 0){
            const allergensList = [];
            for (let i=0; i<allergens.length; i++)
                allergensList.push(allergens[i]["allergen"])
            res.status(200).send(JSON.stringify({"allergens": allergensList}));
            return;
        }
        res.status(200).send(JSON.stringify({"allergens": []}));
        return;
    }
})


router.get('/infos', needAuth, async (req, res) => {
    const [infos] = await conn.query("SELECT email, username FROM users WHERE id = ?;", [req.user.userId]);
    return res.send(infos);
})

router.closeServer = () => {
    console.log("Users Closed");
  };
  
  
  module.exports = router;