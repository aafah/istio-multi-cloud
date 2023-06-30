'use strict'
const db = require('./db-init')

exports.fetchData = (email) => { //Ottiene User data
    return new Promise((success, failure) => {
        const sql = 'SELECT * FROM USERS where email=?'
        db.all(sql, [email], (err, rows) => {
            if (err) {
                failure(err)
                return
            }
            const UserData = rows.map((row) => ({
                id: row.id,
                color: row.color,
            }))
            success(UserData)
        })
    })
}
