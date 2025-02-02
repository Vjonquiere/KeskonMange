const express = require('express');
const Recipe = require('./routers/recipe');
const Recipes = require('./routers/recipes');
const Calendar = require('./routers/calendar');
const Ingredient = require('./routers/ingredient');
const RecipeBook = require('./routers/recipeBook');
const fs = require('fs');
const Auth = require('./routers/auth');
const Users = require('./routers/user');
var bodyParser = require('body-parser');
const database = require('./module/database');
const token = require('./module/token');
const app = express();
const cors = require('cors');
const https = require('https');
app.locals.port = 8080;
//app.use(express.static('public'));

const privateKey = fs.readFileSync('ssl-cert/private-key.pem', 'utf8');
const certificate = fs.readFileSync('ssl-cert/certificate.pem', 'utf8');
const credentials = { key: privateKey, cert: certificate };

app.use(bodyParser.json());
app.use(
  bodyParser.urlencoded({
    extended: true,
  }),
);

/*try {
  connexion.query("SELECT COUNT(id) FROM recipes WHERE 1=3;");
} catch (error) {
  console.log("Something wrong with database: " + error);
}*/

app.use(cors());
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*'); // Allow all origins
  res.header('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE');
  //res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  next();
});

app.use("/recipe", Recipe);
app.use("/recipes", Recipes);
app.use("/calendar", Calendar);
app.use("/ingredient", Ingredient);
app.use("/books", RecipeBook);
app.use("/user", Users);
app.use("/auth", Auth);

app.get('/server/alive', async (req, res) => {
  res.sendStatus(200);
});
app.get('*', (req, res) => {
    res.sendStatus(404);
});

/*let server = app.listen(app.locals.port, () => {
  
});*/

https.createServer(credentials, app).listen(app.locals.port, () => {
  console.log(`Starting server on port ${app.locals.port}`)
});

app.closeServer = () => {
  Recipe.closeServer();
  Recipes.closeServer();
  Calendar.closeServer();
  Ingredient.closeServer();
  RecipeBook.closeServer();
  Users.closeServer();
  Auth.closeServer();
  database.end();
  token.close();
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

