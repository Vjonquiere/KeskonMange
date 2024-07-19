const express = require('express');
const mariadb = require('mariadb');
const Recipe = require('./routers/recipe')
const Recipes = require('./routers/recipes')
const Calendar = require('./routers/calendar')
var bodyParser = require('body-parser')
const app = express();
const port = 8080;
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

app.get('/server/alive', async (req, res) => {
  res.json(JSON.stringify({ alive: true}));
});
app.get('*', (req, res) => {
    res.send("not found");
});

app.listen(port, () => {
  console.log(`Starting server on port ${port}`)
});

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

