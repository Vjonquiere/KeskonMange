const express = require('express');
const router = express.Router();
const mariadb = require('mariadb');
var bodyParser = require('body-parser');

router.use(bodyParser.json());
router.use(
  bodyParser.urlencoded({
    extended: true,
  }),
);

const conn =  mariadb.createPool({
    host: process.env.DATABASE_HOST, 
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE_NAME
  });


router.get("/create", async (req, res) => {
    if (req.query.name === undefined){
        res.status(400).send("Need to specify a book name");
        return;
    }

    const reg = /^[a-zA-Z0-9\s]+$/; // only chars, spaces and numbers 
    if (reg.test(req.query.name) && req.query.name.length <= 32){
        try {
            await conn.query(`INSERT INTO recipe_books VALUES (null, ?, null, 1);`, [req.query.name]);
        } catch (error) {
            console.log(error)
            res.sendStatus(500);
            return;
        }
        
    }
    res.sendStatus(200);

})



  router.closeServer = () => {
    conn.end();
    console.log("Calendar Closed");
};


module.exports = router;