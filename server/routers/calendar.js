const express = require('express');
const router = express.Router();
const mariadb = require('mariadb');
var bodyParser = require('body-parser');
var calendar = require('node-calendar');

router.use(bodyParser.json());
router.use(
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


/* Need to check for UTC fix:
Request are working but the date returned in are wrong formatted.
If your at GMT+2 your dates will be 2 hours late:
  2024-07-09T00:00:00.000Z -> 2024-09-26T22:00:00.000Z
*/


router.get("/today", async (req, res) => { // Special case of /calendar/coming route (like days = 0)
    let date = new Date();
    let formattedDate = date.toISOString().split('T')[0];
    try {
        const todayEntryRaw = await conn.query("SELECT * FROM calendar WHERE date = ?;", [formattedDate]);
        let todayEntry = Array.from(todayEntryRaw); // Casting to Array to check length
        if (todayEntry.length <= 0){
            res.sendStatus(204); // No recipe found for today
            return;
        } else {
            res.send(JSON.stringify({"recipe": todayEntry  }));
            return;
        }
    
    } catch (error) {
        console.log("error:" + error);
    }
    res.sendStatus(400);

});

router.get("/coming", async (req, res) => {
    if (req.query.days === undefined || isNaN(Number(req.query.days))) {
        res.status(405).send("Day must be a number");
        return;
    }
    let daysToAdd = Number(req.query.days);
    let today = new Date();
    let date = new Date();
    date.setDate(today.getDate() + daysToAdd);
    let formattedDate = date.toISOString().split('T')[0];
    try {
        const dateEntryRaw = await conn.query("SELECT * FROM calendar WHERE date = ?;", [formattedDate]);
        let dateEntry = Array.from(dateEntryRaw); // Casting to Array to check length
        if (dateEntry.length <= 0){
            res.sendStatus(204); // No recipe found for today
            return;
        } else {
            res.send(JSON.stringify({"recipe": dateEntry  }));
            return;
        }
    
    } catch (error) {
        console.log("error:" + error);
    }
    res.sendStatus(400);
})

router.get("/completeMonth", async (req, res) => {
    if (req.query.previous === undefined || isNaN(Number(req.query.previous))) {
        res.status(405).send("The number of month you want to rollback must be a number");
        return;
    }
    let monthToRollback = req.query.previous;
    let today = new Date();
    let date = new Date();
    date.setMonth(today.getMonth() - monthToRollback);
    const year = date.toJSON().split("-")[0]
    const month = date.toJSON().split("-")[1]
    let dateTemplateString = `${year}-${month}-` // Format date like YYYY-MM to get all recipe from the given month
    try {
        const dateEntryRaw = await conn.query("SELECT * FROM calendar WHERE date LIKE Concat(?,'%');", [dateTemplateString]);
        let dateEntry = Array.from(dateEntryRaw); // Casting to Array to check length
        if (dateEntry.length <= 0){
            res.sendStatus(204); // No recipe found for today
            return;
        } else {
            res.send(JSON.stringify({"year": year, "month": month, recipes: dateEntry, "monthTemplate": new calendar.Calendar(1).monthdayscalendar(Number(year), Number(month)) }));
            return;
        }
    
    } catch (error) {
        console.log("error:" + error);
    }
})


router.closeServer = () => {
    conn.end();
    console.log("Calendar Closed");
};


module.exports = router;