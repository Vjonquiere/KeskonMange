DROP DATABASE IF EXISTS keskon_mange;
CREATE DATABASE keskon_mange;
USE keskon_mange;

DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS durations;
DROP TABLE IF EXISTS calendar;
DROP TABLE IF EXISTS ingredients;
DROP TABLE IF EXISTS recipes_ingredients_link;

CREATE TABLE IF NOT EXISTS recipes (id INTEGER AUTO_INCREMENT PRIMARY KEY, title CHARACTER VARYING(128), type CHARACTER VARYING(7), difficulty INT, cost INT, portions INT, vegetarian BOOLEAN, vegan BOOLEAN, hasGluten BOOLEAN, hasLactose BOOLEAN, hasPork BOOLEAN, salty BOOLEAN, sweet BOOLEAN);
CREATE TABLE IF NOT EXISTS calendar (date DATE, recipeId INTEGER, done BOOLEAN, result_img TEXT);
CREATE TABLE IF NOT EXISTS ingredients (id INTEGER AUTO_INCREMENT PRIMARY KEY , name CHARACTER VARYING(32), type CHARACTER VARYING(32));
CREATE TABLE IF NOT EXISTS durations (recipeId INTEGER PRIMARY KEY , total INTEGER, preparation INTEGER, rest INTEGER, cook INTEGER);
CREATE TABLE IF NOT EXISTS recipes_ingredients_link (recipeId INTEGER, ingredientId INTEGER, unit CHARACTER VARYING(16), quantity INTEGER);
CREATE TABLE IF NOT EXISTS recipe_books (id INTEGER AUTO_INCREMENT PRIMARY KEY, name CHARACTER VARYING(32), owner INTEGER, visibility BOOLEAN);
CREATE TABLE IF NOT EXISTS recipe_book_access (bookId INTEGER, userId INTEGER);
CREATE TABLE IF NOT EXISTS recipe_book_links (bookId INTEGER, recipeId INTEGER, dateAdded DATE);
