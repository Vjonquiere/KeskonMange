const express = require("express");
const router = express.Router();
var bodyParser = require("body-parser");
var calendar = require("node-calendar");
var database = require("../module/database");
const conn = database.conn;
const needAuth = require("../module/token").checkApiKey;

router.use(bodyParser.json());
router.use(
  bodyParser.urlencoded({
    extended: true,
  }),
);

/* Need to check for UTC fix:
Request are working but the date returned in are wrong formatted.
If your at GMT+2 your dates will be 2 hours late:
  2024-07-09T00:00:00.000Z -> 2024-09-26T22:00:00.000Z
*/

/**
 * @api [get] /calendar/today
 * tags :
 *  - Calendar
 * description: "Returns the recipe scheduled for today"
 * responses:
 *   "200":
 *     description: "Calendar entry for today"
 *   "204":
 *      description: "There isn't a recipe scheduled for today"
 */
router.get("/today", needAuth, async (req, res) => {
  // Special case of /calendar/coming route (like days = 0)
  let date = new Date();
  let formattedDate = date.toISOString().split("T")[0];
  try {
    const todayEntryRaw = await conn.query(
      "SELECT date, recipeId, done, result_img FROM calendar WHERE date = ? AND userId = ?;",
      [formattedDate, req.user.userId],
    );
    let todayEntry = Array.from(todayEntryRaw); // Casting to Array to check length
    if (todayEntry.length <= 0) {
      res.sendStatus(204); // No recipe found for today
      return;
    } else {
      res.send(JSON.stringify({ recipe: todayEntry }));
      return;
    }
  } catch (error) {
    console.log("error:" + error);
  }
});

/**
 * @api [get] /calendar/coming
 * tags :
 *  - Calendar
 * description: "Returns the recipe scheduled for today+numberOf{days}"
 * parameters:
 * - name: days
 *   in: query
 *   description: Number of days to skip
 *   required: true
 *   type: integer
 *
 * responses:
 *   "200":
 *     description: "Calendar for the given day"
 *   "204":
 *      description: "There isn't a recipe scheduled for this day"
 */
router.get("/coming", needAuth, async (req, res) => {
  if (req.query.days === undefined || isNaN(Number(req.query.days))) {
    res.status(405).send("Day must be a number");
    return;
  }
  let daysToAdd = Number(req.query.days);
  let today = new Date();
  let date = new Date();
  date.setDate(today.getDate() + daysToAdd);
  let formattedDate = date.toISOString().split("T")[0];
  try {
    const dateEntryRaw = await conn.query(
      "SELECT date, recipeId, done, result_img FROM calendar WHERE date = ? AND userId = ?;",
      [formattedDate, req.user.userId],
    );
    let dateEntry = Array.from(dateEntryRaw); // Casting to Array to check length
    if (dateEntry.length <= 0) {
      res.sendStatus(204); // No recipe found for today
      return;
    } else {
      res.send(JSON.stringify({ recipe: dateEntry }));
      return;
    }
  } catch (error) {
    console.log("error:" + error);
  }
});

/**
 * @api [get] /calendar/completeMonth
 * tags :
 *  - Calendar
 * description: "Returns the specified month schema and its planned recipes"
 * parameters:
 * - name: previous
 *   in: query
 *   description: Number of month to go back
 *   required: true
 *   type: integer
 *
 * responses:
 *   "200":
 *     description: "year, month number and month schema"
 *   "204":
 *      description: "No recipe was found for the given month"
 */
router.get("/completeMonth", needAuth, async (req, res) => {
  if (req.query.previous === undefined || isNaN(Number(req.query.previous))) {
    res
      .status(405)
      .send("The number of month you want to rollback must be a number");
    return;
  }
  let monthToRollback = req.query.previous;
  let today = new Date();
  let date = new Date();
  date.setMonth(today.getMonth() - monthToRollback);
  const year = date.toJSON().split("-")[0];
  const month = date.toJSON().split("-")[1];
  let dateTemplateString = `${year}-${month}-`; // Format date like YYYY-MM to get all recipe from the given month
  try {
    const dateEntryRaw = await conn.query(
      "SELECT * FROM calendar WHERE date LIKE Concat(?,'%') AND userId = ?;",
      [dateTemplateString, req.user.userId],
    );
    let dateEntry = Array.from(dateEntryRaw); // Casting to Array to check length
    if (dateEntry.length <= 0) {
      res.sendStatus(204); // No recipe found for today
      return;
    } else {
      res.send(
        JSON.stringify({
          year: Number(year),
          month: Number(month),
          recipes: dateEntry,
          monthTemplate: new calendar.Calendar(1).monthdayscalendar(
            Number(year),
            Number(month),
          ),
        }),
      );
      return;
    }
  } catch (error) {
    console.log("error:" + error);
  }
});

/**
 * @api [get] /calendar/next
 * tags :
 *  - Calendar
 * parameters:
 * - name: count
 *   in: query
 *   description: Number of next recipes to get (between 1 and 10)
 *   required: true
 *   type: integer
 * description: "Returns the next {count} recipes scheduled"
 * responses:
 *   "200":
 *     description: "Calendar entry for today"
 *   "204":
 *      description: "There isn't at least one recipe scheduled"
 *   "405":
 *      description: "A wrong number next recipes to get was given"
 */
router.get("/next", needAuth, async (req, res) => {
  if (req.query.count === undefined || isNaN(Number(req.query.count))) {
    res
      .status(405)
      .send("The number of next planed recipes you want must be a number");
    return;
  }
  let count = Number(req.query.count);
  let date = new Date();
  let formattedDate = date.toISOString().split("T")[0];
  if (count < 1 || count > 10) {
    res.status(405).send("You can get only between 1 and 10 recipes");
    return;
  }
  try {
    let entries = await conn.query(
      "SELECT recipeId, date FROM calendar WHERE date > ? AND userId = ? ORDER BY date ASC LIMIT ?",
      [formattedDate, req.user.userId, count],
    );
    let entriesArray = Array.from(entries);
    if (entries.length < 1) {
      res.sendStatus(204);
      return;
    }
    let response = [];
    for (const entry of entriesArray) {
      response.push([entry["recipeId"], entry["date"]]);
    }
    res.send(JSON.stringify({ recipes: response }));
  } catch (error) {
    console.log(error);
    res.sendStatus(500);
  }
});

router.closeServer = () => {
  console.log("Calendar Closed");
};

module.exports = router;
