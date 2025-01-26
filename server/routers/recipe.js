const express = require('express');
const fs = require('fs');
const router = express.Router();
const axios = require('axios');
const database = require('../module/database');
var bodyParser = require('body-parser');
let port;
const conn = database.conn;
const path = require('path');
const needAuth = require('../module/token').checkApiKey;
const multer  = require('multer');
const upload = multer();
const sharp = require('sharp');

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

async function hasAccess(recipeId, userId) {
    const isPublic = await conn.query("SELECT id FROM recipes WHERE id = ? AND visibility = 0;", [recipeId]);
    const isOwner = await conn.query("SELECT id FROM recipes WHERE id = ? AND owner = ?;", [recipeId, userId]);
    return isPublic.length > 0 || isOwner.length > 0;
    
}

async function hasOwnerAccess(recipeId, userId) {
    const isOwner = await conn.query("SELECT id FROM recipes WHERE id = ? AND owner = ?;", [recipeId, userId]);
    return isOwner.length > 0;
    
}

function isPreparationStep(step){
    return !(!step.type == "preparation" || !step.description);
}

router.get('/complete', async (req, res) => {
    const recipeData = await conn.query("SELECT * FROM recipes JOIN durations ON recipes.id = durations.recipeId WHERE recipes.id=?;", [req.body.id]);
    const ingredienList = await conn.query("SELECT ingredients.name FROM recipes_ingredients_link JOIN ingredients ON ingredients.id = recipes_ingredients_link.ingredientId WHERE recipes_ingredients_link.recipeId=?;", [req.body.id]);
    res.json(JSON.stringify({ recipe: recipeData[0], ingredients : ingredienList}));
});

/**
 * @api [get] /recipe/last
 * tags :
 *  - Recipe
 * description: "Returns the last added recipe"
 * responses:
 *   "200":
 *     description: "Last recipe"
 */
//TODO: add limit for less data trafic
router.get('/last', async (req, res) => {
    const result = await conn.query("SELECT * FROM recipes WHERE visibility = 0 ORDER BY id DESC;");
    res.json(result[0]);
});

/**
 * @api [get] /recipe/image
 * tags :
 *  - Recipe
 * description: "Returns the image of the given recipe"
 * parameters:
 * - name: recipeId
 *   in: query
 *   description: The id of the recipe
 *   required: true
 *   type: integer
 * - name: format
 *   in: query
 *   description: The format of the image (4/3, 16/9, 1/1)
 *   required: true
 *   type: string
 * responses:
 *   "200":
 *     description: "File sent with the given format"
 *    "204":
 *      description: "No file found"
 */
router.get("/image", needAuth, async (req, res) => {
    if (!req.query.recipeId || !req.query.format){
        return res.status(405).send("Missing arguments");
    }
    if (!(await hasAccess(req.query.recipeId, req.user.userId))) return res.sendStatus(204);
    imagePath = `public/images/recipe/${req.query.recipeId}/${req.query.format}.png`;
    fs.access(path.join(__dirname, "../", imagePath), fs.constants.R_OK, (err) => {
        if (err){
            console.log(path.join(__dirname, "../", imagePath));
            return res.sendStatus(204);
        }
      });
    return res.sendFile(imagePath, { root: path.join(__dirname, "../") });
})

/**
 * @api [post] /recipe/image
 * tags :
 *  - Recipe
 * description: "Upload an image to make a recipe preview"
 * parameters:
 * - name: recipeId
 *   in: query
 *   description: The id of the recipe
 *   required: true
 *   type: integer
 * responses:
 *   "200":
 *     description: "File was saved"
 *    "405":
 *      description: "At leaqt one argument is missing"
 */
// TODO: add multipart request to doc
router.post("/image", needAuth, (req, res, next) => {upload.single('image')(req, res, (err) => {if (err) {return res.sendStatus(405);} next();});},  async (req, res) => {
    if (!req.query.recipeId){
        return res.status(405).send("Missing arguments");
    }
    if (!(await hasAccess(req.query.recipeId, req.user.userId))) return res.sendStatus(204); //TODO: check if owner, not only someone that can access the recipe
    imagePath = `public/images/recipe/${req.query.recipeId}/`;
    try{
        fs.accessSync(path.join(__dirname, "../", imagePath), fs.constants.W_OK);
    } catch (err) {
        await fs.promises.mkdir(path.join(__dirname, "../", imagePath));
    }
    sharp(req.file.buffer).resize(1280, 720).toFile(imagePath+"16_9.png");
    sharp(req.file.buffer).resize(720, 720).toFile(imagePath+"1_1.png");
    sharp(req.file.buffer).resize(1280, 960).toFile(imagePath+"4_3.png");
    return res.sendStatus(200);
})

/**
 * @api [post] /recipe/add
 * tags :
 *  - Recipe
 * description: "Create and add a new recipe to server"
 * responses:
 *   "200":
 *     description: "File sent with the given format"
 *    "204":
 *      description: "No file found"
 */
// TODO: add request body
router.post("/add", needAuth, async (req, res) => {
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
        conn.query("INSERT INTO recipes VALUES (null, ?, ?, ?, ?, ?, null, null, null, null, null, ?, ?, ?, 0);", [req.body.title, req.body.type, Number(req.body.difficulty), Number(req.body.cost), Number(req.body.portions), req.body.salty, req.body.sweet, req.user.userId]);
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
        return;
    }
    res.sendStatus(200);

});

/**
 * @api [post] /recipe/steps
 * tags :
 *  - Recipe
 * description: "Set the recipe steps for the given recipe"
 * responses:
 *   "200":
 *     description: "Steps have been saved"
 *    "204":
 *      description: "Recipe not found"
 *    "405":
 *      description: "At least one argument is missing"
 *    "500":
 *      description: "Something went wrong while trying to save the steps file"
 */
router.post("/steps", needAuth, async (req, res) => {
    if (!req.query.recipeId || !req.body.steps){
        return res.status(405).send("Missing argument");
    }
    if (!(await hasOwnerAccess(req.query.recipeId, req.user.userId))) return res.sendStatus(204);
    const steps = Array.from(req.body.steps);
    steps.forEach((step) => {
        //if (!isPreparationStep(step)) return res.sendStatus(500);
        // make this for each step
    });
    // save the json in a file
    stepsPath = `public/steps/${req.query.recipeId}.json`;
    const json = `{"steps":${JSON.stringify(req.body.steps)}}`;
    fs.writeFile(stepsPath, json, (err) => {
        if (err) {
            return res.status(500).send("Error while saving your steps");
        }
        return res.sendStatus(200);
    });
    
})

/**
 * @api [get] /recipe/steps
 * tags :
 *  - Recipe
 * description: "Gives you the steps for the given recipe"
 * responses:
 *   "200":
 *     description: "JSON file of the steps sent"
 *    "204":
 *      description: "No file found"
 *    "405":
 *      description: "RecipeId argument is missing"
 */
router.get("/steps", needAuth, async (req, res) => {
    if (!req.query.recipeId){
        return res.status(405).send("Must provide a recipeId");
    }
    if (!(await hasAccess(req.query.recipeId, req.user.userId))) return res.sendStatus(204);
    stepsPath = `public/steps/${req.query.recipeId}.json`;
    fs.access(stepsPath, fs.constants.R_OK, (err) => {
        if (err){
            return res.sendStatus(204);
        }
      });
    return res.sendFile(stepsPath, { root: path.join(__dirname, "../") });    
})

/**
 * @api [get] /recipe/{id}
 * tags :
 *  - Recipe
 * parameters:
 * - name: id
 *   in: path
 *   description: Id of the recipe
 *   required: true
 *   type: integer
 * description: "Returns the recipe linked to the given id"
 * responses:
 *   "200":
 *     description: "recipe corresponding to the id"
 *   "405":
 *      description: "No recipe found"
 */
router.get("/:id", needAuth, async (req, res) => { //TODO: change params to query + code 204 if no recipe found
    if (req.params.id === undefined || isNaN(Number(req.params.id))){
        res.status(405).send("undifined recipe_id");
        return;
    }
    try {
        if (!(await hasAccess(req.params.id, req.user.userId))) return res.sendStatus(204);
        const result = await conn.query("SELECT * FROM recipes WHERE id = ?;", [req.params.id]);
        res.json(result[0]);
    } catch (error) {
        res.sendStatus(500);
    }
});

router.closeServer = () => {
    console.log("Recipe Closed");
};



module.exports = router;