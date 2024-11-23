const mariadb = require('mariadb');

const connexion =  mariadb.createPool({
    host: process.env.DATABASE_HOST, 
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE_NAME,
    dateStrings: true
  });

function end_connexion(){
  connexion.end();
}

module.exports = {
    conn : connexion,
    end : end_connexion
};