const express = require('express');
const router = express.Router();
const mariadb = require('mariadb');

const conn =  mariadb.createPool({
    host: process.env.DATABASE_HOST, 
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE_NAME
  });

router.get('/byName', async (req, res) => {
    const result = await conn.query("SELECT * FROM recipes WHERE title LIKE Concat('%', ?,'%');", [req.body.name]);
    console.log("/recipes/byName");
    console.log("recipes with the word: ", req.body.name);
    console.log(result);
    res.json(JSON.stringify({ recipes: result}) );
});
  
router.get('/withDuration', async (req, res) => {
    let result;
    switch(req.body.type){
      case 'total':
        result = await conn.query("SELECT * FROM recipes JOIN durations ON recipes.id = durations.recipeId WHERE total=?;", [req.body.time]);
        break;
      case 'preparation':
        result = await conn.query("SELECT * FROM recipes JOIN durations ON recipes.id = durations.recipeId WHERE preparation=?;", [req.body.time]);
        break;
      case 'rest':
        result = await conn.query("SELECT * FROM recipes JOIN durations ON recipes.id = durations.recipeId WHERE rest=?;", [req.body.time]);
        break;
      case 'cook':
        result = await conn.query("SELECT * FROM recipes JOIN durations ON recipes.id = durations.recipeId WHERE cook=?;", [req.body.time]);
        break;
      default:
        console.log(req.body.type);
        res.sendStatus(405);
        return;
    }
    console.log("/recipes/withDuration");
    console.log("recipes with a",req.body.type," duration of : ", req.body.time);
    console.log("numbers of recipes : ",result.length);
    res.json(JSON.stringify({ recipes: result}));
});
  
router.get('/withMaxDuration', async (req, res) => {
    let result;
    switch(req.body.type){
      case 'total':
        result = await conn.query("SELECT * FROM recipes JOIN durations ON recipes.id = durations.recipeId WHERE total<=?;", [req.body.time]);
        break;
      case 'preparation':
        result = await conn.query("SELECT * FROM recipes JOIN durations ON recipes.id = durations.recipeId WHERE preparation<=?;", [req.body.time]);
        break;
      case 'rest':
        result = await conn.query("SELECT * FROM recipes JOIN durations ON recipes.id = durations.recipeId WHERE rest<=?;", [req.body.time]);
        break;
      case 'cook':
        result = await conn.query("SELECT * FROM recipes JOIN durations ON recipes.id = durations.recipeId WHERE cook<=?;", [req.body.time]);
        break;
      default:
        console.log(req.body.type);
        res.sendStatus(400);
        break;
    }
    console.log("/recipes/withMaxDuration");
    console.log("recipes with a",req.body.type," duration of : ", req.body.time);
    console.log("numbers of recipes : ",result.length);
    res.json(JSON.stringify({ recipes: result}));
});
  
router.get('/withIngredient', async (req, res) => {
    const result = await conn.query("SELECT recipes.* FROM recipes_ingredients_link JOIN ingredients ON ingredients.id = recipes_ingredients_link.ingredientId JOIN recipes ON recipes_ingredients_link.recipeId = recipes.id WHERE ingredients.name LIKE Concat('%', ?,'%');", [req.body.ing]);
    console.log("/recipes/withIngredient");
    console.log("recipes with",req.body.ing);
    console.log("nb of recipes with", req.body.ing,"=",result.length);
    res.json(JSON.stringify({ recipes: result}));
});


module.exports = router;