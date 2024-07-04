const express = require('express');
const router = express.Router();
const mariadb = require('mariadb');

const conn =  mariadb.createPool({
    host: process.env.DATABASE_HOST, 
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE_NAME
  });

router.get("/withId", async (req, res) => {
    try {
        const result = await conn.query("SELECT * FROM recipes WHERE id = ?;", [req.body.recipe_id]);
        console.log("/recipe/withId");
        console.log("recipe with id: ", req.body.recipe_id);
        console.log(result[0]);
        res.json(result[0]);
    } catch (error) {
        res.sendStatus(500);
    }
});

router.get('/complete', async (req, res) => {
    const recipeData = await conn.query("SELECT * FROM recipes JOIN durations ON recipes.id = durations.recipeId WHERE recipes.id=?;", [req.body.id]);
    const ingredienList = await conn.query("SELECT ingredients.name FROM recipes_ingredients_link JOIN ingredients ON ingredients.id = recipes_ingredients_link.ingredientId WHERE recipes_ingredients_link.recipeId=?;", [req.body.id])
    console.log("/recipe/complete");
    console.log("recipes nb",req.body.id);
    res.json(JSON.stringify({ recipe: recipeData[0], ingredients : ingredienList}));
});

//TODO: add limit for less data trafic
router.get('/last', async (req, res) => {
    const result = await conn.query("SELECT * FROM recipes ORDER BY id DESC;");
    console.log("/recipe/last")
    console.log("last recipe scrapped : ",result[0]);
    res.json(result[0]);
});

module.exports = router;