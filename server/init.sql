DROP DATABASE IF EXISTS keskon_mange;
CREATE DATABASE keskon_mange;
USE keskon_mange;

DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS durations;
DROP TABLE IF EXISTS calendar;
DROP TABLE IF EXISTS ingredients;
DROP TABLE IF EXISTS recipes_ingredients_link;

CREATE TABLE IF NOT EXISTS recipes (id BIGINT PRIMARY KEY AUTO_INCREMENT, title CHARACTER VARYING(128), type CHARACTER VARYING(7), difficulty INT, cost INT, portions INT, vegetarian BOOLEAN, vegan BOOLEAN, hasGluten BOOLEAN, hasLactose BOOLEAN, hasPork BOOLEAN, salty BOOLEAN, sweet BOOLEAN);
CREATE TABLE IF NOT EXISTS calendar (timestamp BIGINT, recipeId BIGINT, done BOOLEAN);
CREATE TABLE IF NOT EXISTS ingredients (id BIGINT PRIMARY KEY AUTO_INCREMENT, name CHARACTER VARYING(32));
CREATE TABLE IF NOT EXISTS durations (recipeId BIGINT, total INTEGER, preparation INTEGER, rest INTEGER, cook INTEGER);
CREATE TABLE IF NOT EXISTS recipes_ingredients_link (recipeId BIGINT, ingredientId BIGINT, unit CHARACTER VARYING(16), quantity INTEGER);
