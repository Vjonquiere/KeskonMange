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
    const usernameUnique = await conn.query("SELECT * FROM user WHERE username = ?;", [req.query.username]);
    if (!emailUnique){
        res.status(405).send("Email is already used, try connect instead");
        return;
    }
    if (!usernameUnique){
        res.status(405).send("This username is taken by another user, find a new one!");
        return;
    }
    
    

})

router.closeServer = () => {
    conn.end()
    console.log("Recipes Closed");
  };
  
  
  module.exports = router;