const express = require("express");
const router = express.Router();
var bodyParser = require("body-parser");
var database = require("../module/database");
const mailer = require("../module/mailer");
const token = require("../module/token");
const conn = database.conn;

var waitingAuths = {};

router.use(bodyParser.json());
router.use(
  bodyParser.urlencoded({
    extended: true,
  }),
);

function generateVerificationCode() {
  let code = "";
  const chars = "0123456789";
  const charactersLength = chars.length;
  for (i = 0; i < 4; i++) {
    code += chars.charAt(Math.floor(Math.random() * charactersLength));
  }
  return code;
}

/**
 * @api [post] /auth/signin
 * tags :
 *  - Auth
 * description: "Create a new signin request or generate token depends on which arguements are given"
 * parameters:
 * - name: email
 *   in: query
 *   description: The email of the account you want to create a new connexion
 *   required: true
 *   type: string
 * - name: lang
 *   in: query
 *   description: The language of the mail
 *   required: false
 *   type: string
 * - name: code
 *   in: query
 *   description: If present, check if an entry is valid for given email and code, if true it generates token and send it to the user
 *   required: false
 *   type: number
 *
 * responses:
 *   "200":
 *     description: "A new connexion has been initialized"
 *   "404":
 *     description: "No matching email"
 *   "405":
 *      description: "Email argument is missing"
 */
router.post("/signin", async (req, res) => {
  if (req.query.email === undefined) {
    res.status(405).send("You must specify the email you want to log in");
    return;
  }
  if (req.query.code === undefined) {
    // Create a code and send to user
    const userExists = Array.from(
      await conn.query("SELECT COUNT(id) FROM users WHERE email = ?;", [
        req.query.email,
      ]),
    );
    if (userExists.length > 0 && Number(userExists[0]["COUNT(id)"]) == 1) {
      waitingAuths[req.query.email] = generateVerificationCode();
      console.log(
        "Mail sent to " +
          req.query.email +
          " status: " +
          (await mailer.sendAuthCode(
            req.query.email,
            waitingAuths[req.query.email],
            req.query.lang,
          )),
      );
      res.sendStatus(200);
    } else {
      res.status(404).send("No user found with this mail");
      return;
    }
  } else {
    if (waitingAuths[req.query.email] == req.query.code) {
      waitingAuths[req.query.email] = undefined;
      const userToken = await token.generateAuthToken(req.query.email);
      const [user] = await conn.query(
        "SELECT username FROM users WHERE email = ?;",
        [req.query.email],
      );
      res
        .status(200)
        .send(JSON.stringify({ token: userToken, username: user.username }));
      return;
    }
    res.sendStatus(404);
  }
  res.sendStatus(404);
});

/**
 * @api [post] /auth/test
 * tags :
 *  - Auth
 * description: "Check if the authentication is possible with the given key and email"
 * parameters:
 * - name: email
 *   in: query
 *   description: The email of the account you want to check validity
 *   required: true
 *   type: string
 * - name: api_key
 *   in: query
 *   description: The user API key
 *   required: true
 *   type: string
 *
 * responses:
 *   "200":
 *     description: "Token is valid"
 *   "204":
 *     description: "No matching data"
 *   "410":
 *      description: "The connexion token has expired"
 *   "405":
 *      description: "Missing argument"
 */
router.post("/test", async (req, res) => {
  if (req.query.email === undefined || req.query.api_key === undefined) {
    res
      .status(405)
      .send("You must specify the email and the token you want to check");
    return;
  }
  const tokenValidity = Array.from(
    await conn.query(
      "SELECT userId, expire FROM authentication WHERE token = ?;",
      [token.getApiKeyHash(req.query.api_key)],
    ),
  );
  if (tokenValidity.length > 0) {
    const userEmail = await conn.query(
      "SELECT email FROM users WHERE id = ?;",
      [tokenValidity[0]["userId"]],
    );
    if (userEmail[0]["email"] == req.query.email) {
      let today = new Date();
      let expire_date = new Date(tokenValidity[0]["expire"]);
      if (today <= expire_date) {
        res.sendStatus(200);
        return;
      } else {
        res.status(410).send("Your access token has expired");
        return;
        // TODO: remove or renew the token
      }
    }
  }
  res.sendStatus(204);
});

/**
 * @api [post] /auth/logout
 * tags :
 *  - Auth
 * description: "Delete the given api-key if it correspond the the given email"
 * parameters:
 * - name: email
 *   in: query
 *   description: The email of the account you want to delete the access
 *   required: true
 *   type: string
 * - name: api_key
 *   in: query
 *   description: The user API key
 *   required: true
 *   type: string
 *
 * responses:
 *   "200":
 *     description: "API key has been deleted"
 *   "204":
 *     description: "No matching data"
 *   "405":
 *      description: "Missing argument"
 */
router.post("/logout", async (req, res) => {
  if (req.query.api_key === undefined || req.query.email === undefined) {
    return res.sendStatus(405);
  }
  const hashedToken = token.getApiKeyHash(req.query.api_key);
  const isTokenValid = Array.from(
    await conn.query(
      "SELECT userId FROM authentication JOIN users ON authentication.userId = users.id WHERE token = ? AND email = ?;",
      [hashedToken, req.query.email],
    ),
  );
  if (isTokenValid.length == 1) {
    await conn.query("DELETE FROM authentication WHERE token = ?", [
      hashedToken,
    ]);
    return res.sendStatus(200);
  }
  return res.sendStatus(204);
});

router.closeServer = () => {
  console.log("Auth Closed");
};

module.exports = router;
