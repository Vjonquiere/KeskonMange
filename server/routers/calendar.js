const express = require('express');
const router = express.Router();
const mariadb = require('mariadb');

router.get("/", (req, res) => {
    res.send("test")
});

router.closeServer = () => {
    console.log("Calendar Closed");
};


module.exports = router;