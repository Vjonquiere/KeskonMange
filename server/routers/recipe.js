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

const conn =  mariadb.createPool({
    host: process.env.DATABASE_HOST, 
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE_NAME
  });

function removeBigInt(recipe){
    recipe["id"] = Number(recipe["id"]); // Convert BigInt to int for json serialize
    return recipe;
}


router.get('/complete', async (req, res) => {
    const recipeData = await conn.query("SELECT * FROM recipes JOIN durations ON recipes.id = durations.recipeId WHERE recipes.id=?;", [req.body.id]);
    const ingredienList = await conn.query("SELECT ingredients.name FROM recipes_ingredients_link JOIN ingredients ON ingredients.id = recipes_ingredients_link.ingredientId WHERE recipes_ingredients_link.recipeId=?;", [req.body.id]);
    res.json(JSON.stringify({ recipe: recipeData[0], ingredients : ingredienList}));
});

//TODO: add limit for less data trafic
router.get('/last', async (req, res) => {
    const result = await conn.query("SELECT * FROM recipes ORDER BY id DESC;");
    res.json(removeBigInt(result[0]));
});

router.get("/:id", async (req, res) => {
    if (req.params.id === undefined || isNaN(Number(req.params.id))){
        res.status(405).send("undifined recipe_id");
        return;
    }
    try {
        const result = await conn.query("SELECT * FROM recipes WHERE id = ?;", [req.params.id]);
        res.json(removeBigInt(result[0]));
    } catch (error) {
        res.sendStatus(500);
    }
});


router.closeServer = () => {
    conn.end();
    console.log("Recipe Closed");
};



module.exports = router;