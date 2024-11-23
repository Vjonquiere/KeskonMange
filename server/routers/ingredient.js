const express = require('express');
const router = express.Router();
const database = require('../module/database');
var bodyParser = require('body-parser');
const conn = database.conn;

const units = {
    "liquid":["l", "g"], 
    "fruit":["piece", "g"],
    "vegetable":["piece", "g"],
    "oil":["g", "PM"], 
    "grocerie":["g", "PM"], 
    "fish":["g", "piece"], 
    "meat":["g", "piece"],
    "cremerie":["g", "l"],
    "egg":["piece"],
    "herb":["bunch", "g"]
}


router.use(bodyParser.json());
router.use(
  bodyParser.urlencoded({
    extended: true,
  }),
);


router.get("/name", async (req, res) => {
    if (req.query.name === undefined || !(typeof req.query.name === 'string')){
        res.status(405).send("undefined ingredient name");
        return;
    }
    try {
        const ingredient = await conn.query("SELECT * FROM ingredients WHERE name=?;", [req.query.name]);
        if (ingredient.length <= 0){
            res.sendStatus(204);
            return;
        }
        res.json(JSON.stringify(ingredient[0]));
    } catch (error) {
        res.sendStatus(500);
    }
});

router.get("/units", async (req, res) => {
    if (req.query.name === undefined || !(typeof req.query.name === 'string')){
        res.status(405).send("undefined ingredient name");
        return;
    }
    try {
        const ingredient = await conn.query("SELECT type FROM ingredients WHERE name=?;", [req.query.name]);
        if (ingredient.length <= 0){
            res.sendStatus(204);
            return;
        }
        res.json(JSON.stringify({units:units[ingredient[0]["type"]]}));
    } catch (error) {
        res.sendStatus(500);
    }
});


router.post("/add", async (req, res) => {
    if (req.body.name === undefined || !(typeof req.body.name === 'string') || req.body.type === undefined || !(typeof req.body.type === 'string')){
        res.status(405).send("undefined ingredient name or type");
        return;
    }
    try {
        const isAlreadyIndexed = await conn.query("SELECT * FROM ingredients WHERE name=?;", [req.body.name]);
        if ((units[req.body.type] === undefined)){
            res.status(405).send("given type is invalid");
            return;
        }
        if (isAlreadyIndexed.length <= 0){
            await conn.query("INSERT INTO ingredients VALUES (null, ?, ?);", [req.body.name, req.body.type]);
            res.status(200).send("ingredient added");
            return;
        }
        res.status(200).send("ingredient already indexed");
    } catch (error) {
        res.sendStatus(500);
    }
});

router.closeServer = () => {
    console.log("Ingredient Closed");
};


module.exports = router;