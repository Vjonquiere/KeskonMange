const mariadb = require('mariadb');

const connexion =  mariadb.createPool({
    host: process.env.DATABASE_HOST, 
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE_NAME,
    multipleStatements: true,
    dateStrings: true
  });


async function clearDatabase() {
    await connexion.query(
        `DROP DATABASE IF EXISTS ${process.env.DATABASE_NAME};
        CREATE DATABASE ${process.env.DATABASE_NAME};
        USE ${process.env.DATABASE_NAME};

        DROP TABLE IF EXISTS recipes;
        DROP TABLE IF EXISTS durations;
        DROP TABLE IF EXISTS calendar;
        DROP TABLE IF EXISTS ingredients;
        DROP TABLE IF EXISTS recipes_ingredients_link;
        DROP TABLE IF EXISTS recipe_books;
        DROP TABLE IF EXISTS recipe_book_access;
        DROP TABLE IF EXISTS recipe_book_links;
        DROP TABLE IF EXISTS users;
        DROP TABLE IF EXISTS verify;
        DROP TABLE IF EXISTS authentication;
        DROP TABLE IF EXISTS allergens;


        CREATE TABLE IF NOT EXISTS recipes (id INTEGER AUTO_INCREMENT PRIMARY KEY, title CHARACTER VARYING(128), type CHARACTER VARYING(7), difficulty INT, cost INT, portions INT, vegetarian BOOLEAN, vegan BOOLEAN, hasGluten BOOLEAN, hasLactose BOOLEAN, hasPork BOOLEAN, salty BOOLEAN, sweet BOOLEAN);
        CREATE TABLE IF NOT EXISTS calendar (date DATE, recipeId INTEGER, done BOOLEAN, result_img TEXT);
        CREATE TABLE IF NOT EXISTS ingredients (id INTEGER AUTO_INCREMENT PRIMARY KEY , name CHARACTER VARYING(32), type CHARACTER VARYING(32));
        CREATE TABLE IF NOT EXISTS durations (recipeId INTEGER PRIMARY KEY , total INTEGER, preparation INTEGER, rest INTEGER, cook INTEGER);
        CREATE TABLE IF NOT EXISTS recipes_ingredients_link (recipeId INTEGER, ingredientId INTEGER, unit CHARACTER VARYING(16), quantity INTEGER);
        CREATE TABLE IF NOT EXISTS recipe_books (id INTEGER AUTO_INCREMENT PRIMARY KEY, name CHARACTER VARYING(32), owner INTEGER, visibility BOOLEAN);
        CREATE TABLE IF NOT EXISTS recipe_book_access (bookId INTEGER, userId INTEGER);
        CREATE TABLE IF NOT EXISTS recipe_book_links (bookId INTEGER, recipeId INTEGER, dateAdded DATE);
        CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTO_INCREMENT, email CHARACTER VARYING(64), username CHARACTER VARYING(16), verified DATE);
        CREATE TABLE IF NOT EXISTS verify (email CHARACTER VARYING(64), code INTEGER);
        CREATE TABLE IF NOT EXISTS authentication (token CHARACTER(64), userId INTEGER, created DATE, expire DATE, renew INTEGER);
        CREATE TABLE IF NOT EXISTS allergens (userId INTEGER, allergenId INTEGER);`
    )
}

function end_connexion(){
    connexion.end();
}

module.exports = {
    clearDatabase : clearDatabase,
    end_connexion : end_connexion,
}