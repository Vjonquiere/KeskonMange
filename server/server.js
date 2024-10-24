const express = require('express');
const Recipe = require('./routers/recipe')
const Recipes = require('./routers/recipes')
const Calendar = require('./routers/calendar')
const Ingredient = require('./routers/ingredient')
const RecipeBook = require('./routers/recipeBook')
var bodyParser = require('body-parser')
const app = express();
app.locals.port = 8080;
//app.use(express.static('public'));

app.use(bodyParser.json());
app.use(
  bodyParser.urlencoded({
    extended: true,
  }),
);

app.use("/recipe", Recipe);
app.use("/recipes", Recipes);
app.use("/calendar", Calendar);
app.use("/ingredient", Ingredient);
app.use("/books", RecipeBook);

app.get('/server/alive', async (req, res) => {
  res.sendStatus(200);
});
app.get('*', (req, res) => {
    res.sendStatus(404);
});

let server = app.listen(app.locals.port, () => {
  console.log(`Starting server on port ${app.locals.port}`)
});

app.closeServer = () => {
  Recipe.closeServer();
  Recipes.closeServer();
  Calendar.closeServer();
  Ingredient.closeServer();
  RecipeBook.closeServer();
  server.close();
};

module.exports = app;


/*app.post('/count/ingredients', async (req, res) => {
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
})*/

