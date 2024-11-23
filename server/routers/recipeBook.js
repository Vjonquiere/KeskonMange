const express = require('express');
const router = express.Router();
const database = require('../module/database');
const conn = database.conn;
var bodyParser = require('body-parser');

router.use(bodyParser.json());
router.use(
  bodyParser.urlencoded({
    extended: true,
  }),
);


async function bookExist(bookId){
  let exists = await conn.query(`SELECT COUNT(id) FROM recipe_books WHERE id=?;`, [bookId]);
  return exists[0]['COUNT(id)'] <= 0;
}

/**
 * @api [post] /books/create
 * tags :
 *  - Book
 * parameters:
 * - name: name
 *   in: query
 *   description: Name of the book
 *   required: true
 *   type: string
 * description: "Create a new book with the specified name"
 * responses:
 *   "200":
 *     description: "Book has been created"
 *   "400":
 *      description: "Name parameter is wrong"
 */
router.post("/create", async (req, res) => {
    if (req.query.name === undefined){
        res.status(400).send("Need to specify a book name");
        return;
    }

    const reg = /^[a-zA-Z0-9\s]+$/; // only chars, spaces and numbers 
    if (reg.test(req.query.name) && req.query.name.length <= 32){
        try {
            await conn.query(`INSERT INTO recipe_books VALUES (null, ?, null, 1);`, [req.query.name]);
        } catch (error) {
            console.log(error)
            res.sendStatus(500);
            return;
        }
        
    } else {
      res.status(400).send("Book name is invalid");
      return;
    }
    res.sendStatus(200);

})

/**
 * @api [delete] /books/delete
 * tags :
 *  - Book
 * parameters:
 * - name: bookId
 *   in: query
 *   description: Name of the book
 *   required: true
 *   type: integer
 * description: "Delete the book with the specified id"
 * responses:
 *   "200":
 *     description: "Book has been deleted"
 *   "400":
 *      description: "BookId parameter is wrong"
 */
router.delete("/delete", async (req, res) => {
  if (req.query.bookId === undefined){
    res.status(400).send("You need to specify a bookId to delete");
    return;
  }
  try {
    // Need to check if the req is the owner
    await conn.query(`DELETE FROM recipe_books WHERE id=?;`, [req.query.bookId]);
  } catch (error) {
    console.log(error)
    res.sendStatus(500);
    return;
  }
  res.sendStatus(200);
})

/**
 * @api [post] /books/share
 * tags :
 *  - Book
 * parameters:
 * - name: bookId
 *   in: query
 *   description: Id of the book
 *   required: true
 *   type: integer
 * - name: userId
 *   in: query
 *   description: Id of the user you want to share the book with
 *   required: true
 *   type: integer
 * description: "Share the given book with the specified user"
 * responses:
 *   "200":
 *     description: "The book is now shared"
 *   "400":
 *      description: "One of the parameter is wrong"
 *   "500":
 *      description: "The book you want to share does not exists"
 */
router.post("/share", async (req, res) => {
  if (req.query.bookId === undefined || req.query.userId === undefined){
    res.status(400).send("Specify a bookId and the user you want to share the book with");
    return;
  }
  try {
    // Need to check if the req is the owner
    if (await bookExist(req.query.bookId)){
      res.status(500).send("Can't share given book: no matching id");
      return;
    }
    await conn.query(`INSERT INTO recipe_book_access VALUES (?,?);`, [req.query.bookId, req.query.userId]);
  } catch (error) {
    console.log(error)
    res.sendStatus(500);
    return;
  }
  res.sendStatus(200);
})

/**
 * @api [get] /books/recipes
 * tags :
 *  - Book
 * parameters:
 * - name: bookId
 *   in: query
 *   description: Id of the book
 *   required: true
 *   type: integer
 * description: "Get all the recipes from a given book"
 * responses:
 *   "200":
 *     description: "Book has been created"
 *   "400":
 *     description: "Something wrong with bookId"
 *   "500":
 *      description: "The book does not exists"
 */
router.get("/recipes", async (req, res) => {
  if (req.query.bookId === undefined){
      res.status(400).send("Need to specify a bookId");
      return;
  }
  try {
      if (await bookExist(req.query.bookId)){
        res.status(500).send("Can't get recipes from given book: no matching id");
        return;
      }
      const recipesRaw = await conn.query(`SELECT recipeId FROM recipe_book_links WHERE bookId = ?;`, [req.query.bookId]);
      let recipes = Array.from(recipesRaw);
      let ids = [];
      for(const recipe  of recipes){
        ids.push(recipe["recipeId"]);
      }
      res.send(JSON.stringify({"recipes": ids}));
      return;
  } catch (error) {
      console.log(error)
      res.sendStatus(500);
      return;
  }
  res.sendStatus(200);

})

/**
 * @api [get] /books/general_information
 * tags :
 *  - Book
 * parameters:
 * - name: bookId
 *   in: query
 *   description: Id of the book
 *   required: true
 *   type: integer
 * description: "Get the general information of a book"
 * responses:
 *   "200":
 *     description: "The general informations"
 *   "400":
 *      description: "BookId parameter is wrong"
 */
router.get("/general_information", async (req, res) => {
  if (req.query.bookId === undefined){
    res.status(400).send("You need to specify a bookId to search for");
    return;
  }
  try {
    const info = await conn.query(`SELECT * FROM recipe_books WHERE id=?;`, [req.query.bookId]);
    let bookInfo = Array.from(info); // Casting to Array to check length
        if (bookInfo.length <= 0){
            res.sendStatus(204); // No book found with the given id
            return;
        // add an else if to know if we are authorized to read it
        } else {
            let countRes =  await conn.query(`SELECT COUNT(bookId) FROM recipe_book_links WHERE bookId=?;`, [req.query.bookId]);
            let count = Number(countRes[0]['COUNT(bookId)']);
            res.send(JSON.stringify({"id": bookInfo[0]["id"], "name":  bookInfo[0]["name"], "owner": bookInfo[0]["owner"], "visibility": bookInfo[0]["visibility"], "recipe_count": count }));
            return;
        }
  } catch (error) {
    console.log(error)
    res.sendStatus(500);
    return;
  }

})

/**
 * @api [get] /books/id
 * tags :
 *  - Book
 * parameters:
 * - name: bookName
 *   in: query
 *   description: Name of the book
 *   required: true
 *   type: string
 * description: "Get the id for a given book name"
 * responses:
 *   "200":
 *     description: "Book has been created"
 *   "204":
 *     description: "No book found with the given name"
 *   "400":
 *      description: "Name parameter is wrong"
 */
router.get("/id", async (req, res) => { //TODO: check for multiple names
  if (req.query.bookName === undefined){
    res.status(400).send("You need to specify a book name to search");
    return;
  }
  try {
    const info = await conn.query(`SELECT * FROM recipe_books WHERE name=?;`, [req.query.bookName]);
    let bookInfo = Array.from(info); // Casting to Array to check length
        if (bookInfo.length <= 0){
            res.sendStatus(204); // No book found with the given id
            return;
        // check the owner name
        } else {
            res.send(JSON.stringify({"id": bookInfo[0]["id"]}));
            return;
        }
  } catch (error) {
    console.log(error)
    res.sendStatus(500);
    return;
  }

})

/**
 * @api [get] /books/recipe/add
 * tags :
 *  - Book
 * parameters:
 * - name: bookId
 *   in: query
 *   description: Id of the book
 *   required: true
 *   type: integer
  * - name: recipeId
 *   in: query
 *   description: Id of the recipe
 *   required: true
 *   type: integer
 * description: "Add the recipe to the book"
 * responses:
 *   "200":
 *     description: "Book has been created"
 *   "500":
 *     description: "The book does not exists"
 *   "400":
 *      description: "At least one parameter is wrong"
 */
router.post("/recipe/add", async (req, res) => {
  if (req.query.bookId === undefined || req.query.recipeId === undefined){
    res.status(400).send("You need to specify a bookId and a recipeId");
    return;
  }
  let date = new Date();
  let formattedDate = date.toISOString().split('T')[0];
  try {
    if (await bookExist(req.query.bookId)){
      res.status(500).send("Can't add recipe to given book: no matching id");
      return;
    }
    // need to check if requester is the owner of the book
    await conn.query(`INSERT INTO recipe_book_links VALUES (?, ?, ?);`, [req.query.bookId, req.query.recipeId, formattedDate]);
  } catch (error) {
    console.log(error);
    res.sendStatus(500);
    return;
  }
  res.sendStatus(200);
})

/**
 * @api [delete] /books/share
 * tags :
 *  - Book
 * parameters:
 * - name: bookId
 *   in: query
 *   description: Id of the book
 *   required: true
 *   type: integer
* - name: userId
 *   in: query
 *   description: Id of the user
 *   required: true
 *   type: integer
 * description: "Delete the book"
 * responses:
 *   "200":
 *     description: "Book has been deleted"
 *   "400":
 *      description: "At least one parameter is wrong"
 */
router.delete("/share", async (req, res) => {
  if (req.query.bookId === undefined || req.query.userId === undefined){
    res.status(400).send("You need to specify a bookId and a userId");
    return;
  }
  try {
    // need to check if requester is the owner of the book
    await conn.query(`DELETE FROM recipe_book_access WHERE bookId = ? AND userId = ?;`, [req.query.bookId, req.query.userId]);
  } catch (error) {
    console.log(error);
    res.sendStatus(500);
    return;
  }
  res.sendStatus(200);
})

router.closeServer = () => {
    console.log("Calendar Closed");
};


module.exports = router;