const express = require('express');
const router = express.Router();
const mariadb = require('mariadb');
var bodyParser = require('body-parser')

router.use(bodyParser.json());
router.use(
  bodyParser.urlencoded({
    extended: true,
  }),
);

function removeBigInt(ingredient){
    ingredient["id"] = Number(ingredient["id"]); // Convert BigInt to int for json serialize
    return ingredient;
}

const conn =  mariadb.createPool({
    host: process.env.DATABASE_HOST, 
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE_NAME
  });


router.get("/", (req, res) => {
    res.sendStatus(400);
});

router.get("/name", async (req, res) => {
    if (req.query.name === undefined || !(typeof req.query.name === 'string')){
        res.status(405).send("undifined ingredient name");
        return;
    }
    try {
        const ingredient = await conn.query("SELECT * FROM ingredients WHERE name=?;", [req.query.name]);
        if (ingredient.length <= 0){
            res.status(404).send("unknown ingredient");
            return;
        }
        res.json(JSON.stringify(removeBigInt(ingredient[0])));
    } catch (error) {
        res.sendStatus(500);
    }
    
});

router.post("/add", async (req, res) => {
    if (req.body.name === undefined || !(typeof req.body.name === 'string')){
        res.status(405).send("undifined ingredient name");
        return;
    }
    try {
        const isAlreadyIndexed = await conn.query("SELECT * FROM ingredients WHERE name=?;", [req.body.name]);
        if (isAlreadyIndexed.length <= 0){
            await conn.query("INSERT INTO ingredients VALUES (null, ?);", [req.body.name]);
            res.status(200).send("ingredient added");
            return;
        }
        res.status(200).send("ingredient already indexed");
    } catch (error) {
        res.sendStatus(500);
    }
});

router.closeServer = () => {
    conn.end();
    console.log("Ingredient Closed");
};


module.exports = router;