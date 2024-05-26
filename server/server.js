const express = require('express');
const mariadb = require('mariadb');
var bodyParser = require('body-parser')
const app = express();
const port = 8080;
app.use(express.static('public'));

app.use(bodyParser.json());
app.use(
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

function separator(){
  console.log("_________________________________________________________")
}

app.listen(port, () => {
    console.log(`Starting server on port ${port}`)
})

app.post('/recipe/withId', async (req, res) => {
    const result = await conn.query("SELECT * FROM recipes WHERE id = ?;", [req.body.recipe_id]);
    console.log("/recipe/withId");
    console.log("recipe with id: ", req.body.recipe_id);
    console.log(result[0]);
    separator();
    res.json(result[0]);
})

app.post('/recipe/complete', async (req, res) => {
  const r1 = await conn.query("SELECT * FROM recipes JOIN durations ON recipes.id = durations.recipeId WHERE recipes.id=?;", [req.body.id]);
  const r2 = await conn.query("SELECT ingredients.name FROM recipes_ingredients_link JOIN ingredients ON ingredients.id = recipes_ingredients_link.ingredientId WHERE recipes_ingredients_link.recipeId=?;", [req.body.id])
  console.log("/recipe/complete");
  console.log("recipes nb",req.body.id);
  separator();
  res.json(JSON.stringify({ recipe: r1[0], ingredients : r2}));
})

app.post('/recipe/last', async (req, res) => {
  const result = await conn.query("SELECT * FROM recipes ORDER BY id DESC;");
  console.log("/recipe/last")
  console.log("last recipe scrapped : ",result[0]);
  separator();
  res.json(result[0]);
})

app.post('/recipes/byName', async (req, res) => {
  const result = await conn.query("SELECT * FROM recipes WHERE title LIKE Concat('%', ?,'%');", [req.body.name]);
  console.log("/recipes/byName");
  console.log("recipes with the word: ", req.body.name);
  console.log(result);
  separator();
  res.json(JSON.stringify({ recipes: result}) );
})

app.post('/recipes/withDuration', async (req, res) => {
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
      res.sendStatus(400);
      break;
  }
  console.log("/recipes/withDuration");
  console.log("recipes with a",req.body.type," duration of : ", req.body.time);
  console.log("numbers of recipes : ",result.length);
  separator();
  res.json(JSON.stringify({ recipes: result}));
})

app.post('/recipes/withMaxDuration', async (req, res) => {
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
  separator()
  res.json(JSON.stringify({ recipes: result}));
})

app.post('/recipes/withIngredient', async (req, res) => {
  const result = await conn.query("SELECT recipes.* FROM recipes_ingredients_link JOIN ingredients ON ingredients.id = recipes_ingredients_link.ingredientId JOIN recipes ON recipes_ingredients_link.recipeId = recipes.id WHERE ingredients.name LIKE Concat('%', ?,'%');", [req.body.ing]);
  console.log("/recipes/withIngredient");
  console.log("recipes with",req.body.ing);
  console.log("nb of recipes with", req.body.ing,"=",result.length);
  separator();
  res.json(JSON.stringify({ recipes: result}));
})

app.post('/count/ingredients', async (req, res) => {
  const result = await conn.query("SELECT COUNT(*) as count FROM ingredients ;");
  console.log("/count/ingredients");
  console.log("number of ingredients in the data base:", Number(result[0]["count"]));
  separator()
  res.json(JSON.stringify({ count: Number(result[0]["count"])}));
})

app.post('/count/recipes', async (req, res) => {
  const result = await conn.query("SELECT COUNT(*) as count FROM recipes;");
  console.log("/count/recipes")
  console.log("number of recipes : ",Number(result[0]["count"]));
  separator();
  res.json(JSON.stringify({ count: Number(result[0]["count"])}));
})

app.post('/server/alive', async (req, res) => {
  res.json(JSON.stringify({ alive: true}));
})

app.get('*', (req, res) => {
    console.log(req.ip);
    res.send("not found");
})