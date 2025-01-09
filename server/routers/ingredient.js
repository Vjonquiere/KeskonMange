const express = require('express');
const router = express.Router();
const database = require('../module/database');
var bodyParser = require('body-parser');
const constants = require('../module/constants');
const token = require("../module/token");
const conn = database.conn;

const units = constants.units;

router.use(bodyParser.json());
router.use(
  bodyParser.urlencoded({
    extended: true,
  }),
);

/**
 * @api [get] /ingredient/name
 * tags : 
 *  - Ingredients
 * description: "Return the ingredient informations for the given name"
 * parameters:
 * - name: name
 *   in: query
 *   description: Name of the ingredient to get
 *   required: true
 *   type: string
 *
 * responses:
 *   "200":
 *     description: "Ingredient infos"
 *   "204":
 *      description: "There isn't an ingredient named like requested"
 *   "405":
 *      description: "Something is wrong in request parameters"
 */
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

/**
 * @api [get] /ingredient/units
 * tags : 
 *  - Ingredients
 * description: "Return the units linked to the given ingredient name"
 * parameters:
 * - name: name
 *   in: query
 *   description: Name of the ingredient
 *   required: true
 *   type: string
 *
 * responses:
 *   "200":
 *     description: "Ingredient units"
 *   "204":
 *      description: "There isn't units linked to the ingredient name specified"
 *   "405":
 *      description: "Something is wrong in request parameters"
 */
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

/**
 * @api [post] /ingredient/add
 * tags : 
 *  - Ingredients
 * description: "Add the specified ingredient to the known ingredients"
 * parameters:
 * - name: name
 *   in: query
 *   description: Name of the ingredient
 *   required: true
 *   type: string
 * - name: type
 *   in: query
 *   description: Type of the ingredient
 *   required: true
 *   type: string
 * responses:
 *   "200":
 *     description: "Ingredient has been added successfuly or already exixsts"
 *   "405":
 *      description: "Something is wrong in request parameters"
 */
router.post("/add", token.checkApiKey, async (req, res) => {
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
            await conn.query("INSERT INTO ingredients VALUES (null, ?, ?, ?);", [req.body.name, req.body.type, req.user.userId]);
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