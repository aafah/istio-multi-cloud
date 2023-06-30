'use strict'
const sqlite = require('sqlite3')

const db = new sqlite.Database(
    'db/microtwo.db',
    (error) => {
        if (error) throw error;
    }
)
module.exports = db