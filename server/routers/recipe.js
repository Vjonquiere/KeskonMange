const express = require('express');
const router = express.Router();
const mariadb = require('mariadb');
const axios = require('axios');
var bodyParser = require('body-parser');
let port;

router.use(bodyParser.json());
router.use(
  bodyParser.urlencoded({
    extended: true,
  }),
);

router.use((req, res, next) => {
    port = req.app.locals.port;
    next();
});

const conn =  mariadb.createPool({
    host: process.env.DATABASE_HOST, 
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE_NAME
  });


router.get('/complete', async (req, res) => {
    const recipeData = await conn.query("SELECT * FROM recipes JOIN durations ON recipes.id = durations.recipeId WHERE recipes.id=?;", [req.body.id]);
    const ingredienList = await conn.query("SELECT ingredients.name FROM recipes_ingredients_link JOIN ingredients ON ingredients.id = recipes_ingredients_link.ingredientId WHERE recipes_ingredients_link.recipeId=?;", [req.body.id]);
    res.json(JSON.stringify({ recipe: recipeData[0], ingredients : ingredienList}));
});

//TODO: add limit for less data trafic
router.get('/last', async (req, res) => {
    const result = await conn.query("SELECT * FROM recipes ORDER BY id DESC;");
    res.json(result[0]);
});

router.get("/:id", async (req, res) => {
    if (req.params.id === undefined || isNaN(Number(req.params.id))){
        res.status(405).send("undifined recipe_id");
        return;
    }
    try {
        const result = await conn.query("SELECT * FROM recipes WHERE id = ?;", [req.params.id]);
        res.json(result[0]);
    } catch (error) {
        res.sendStatus(500);
    }
});

router.post("/add", async (req, res) => {
    if (req.body.title === undefined || req.body.type === undefined || req.body.difficulty === undefined || req.body.cost === undefined || req.body.portions === undefined || req.body.salty === undefined || req.body.sweet === undefined || req.body.ingredients === undefined || req.body.preparation_time === undefined || req.body.rest_time === undefined || req.body.cook_time === undefined){
        res.status(400).send("Please check if all arguments are valid");
        return;
    }
   var ingredients = req.body.ingredients
    if (!Array.isArray(ingredients)){
        res.status(400).send("Ingredient list should be an array");
        return;
    }
    for (let i = 0; i<ingredients.length; i++){ //Check and add missing ingredients
        try {
            const response = await axios.get(`http://localhost:${port}/ingredient/name/?name=${ingredients[i]["name"]}`);
            // TODO: If the ingredient exists, need to check if the given unit is in DB
            if (response.status == 204) {
                res.status(400).send(`${ingredients[i]["name"]} is an unknown ingredient`);
                return;
            } else if (response.status == 200) {
                const units = await axios.get(`http://localhost:${port}/ingredient/units/?name=${ingredients[i]["name"]}`);
                if (units.status != 200 || !(JSON.parse(units.data)["units"].includes(ingredients[i]["unit"]))){
                    res.status(400).send(`Ingredient ${ingredients[i]["name"]} has an unknown unit`);
                    return;
                }
            }
        } catch (error) {
            console.log(error);
            res.status(400).send("Something went wrong with the ingredients");
            return;
        }
    }
    // Check types + total time process
    if (isNaN(Number(req.body.preparation_time))  || isNaN(Number(req.body.rest_time)) || isNaN(Number(req.body.cook_time))){
        res.status(400).send("Time must be a number");
        return;
    }
    const totalTime = Number(req.body.preparation_time) + Number(req.body.rest_time) + Number(req.body.cook_time);

    // Check bool values types (salty, sweet)
    for (const value of [req.body.salty, req.body.sweet]){
        if (value != true && value != false){
            res.status(400).send(`${value} can not be turned into a Boolean`);
            return;
        }
    }

    // Check other number values (difficulty, portions)
    if (isNaN(Number(req.body.difficulty))){
        res.status(400).send("Difficulty must be a number");
        return;
    }
    if (isNaN(Number(req.body.portions))){
        res.status(400).send("Portions must be a number");
        return;
    }
    if (isNaN(Number(req.body.cost))){
        res.status(400).send("Cost must be a number");
        return;
    }
    try {
        conn.query("INSERT INTO recipes VALUES (null, ?, ?, ?, ?, ?, null, null, null, null, null, ?, ?);", [req.body.title, req.body.type, Number(req.body.difficulty), Number(req.body.cost), Number(req.body.portions), req.body.salty, req.body.sweet]);
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
        return;
    }
    res.sendStatus(200);

});

router.closeServer = () => {
    conn.end();
    console.log("Recipe Closed");
};



module.exports = router;