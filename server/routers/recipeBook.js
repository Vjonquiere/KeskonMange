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


router.get("/id", async (req, res) => {
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