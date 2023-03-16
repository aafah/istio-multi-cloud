'use strict'
const db = require('./db-init')

exports.fetchItems = () => { //Ottiene Items
    return new Promise((success, failure) => {
        const sql = 'SELECT * FROM ITEMS'
        db.all(sql, [], (err, rows) => {
            if (err) {
                failure(err)
                return
            }
            const items = rows.map((row) => ({
                id: row.id,
                name: row.name
            }))
            success(items)
        })
    })
}

exports.insertItem = (item) => {
    return new Promise((success, failure) => {
        const sql = `INSERT INTO 
                        ITEMS(id, name)
                            VALUES(?, ?)`
        db.run(sql,
            [
                item.id,
                item.name
            ],
            (err) => {
                if (err) {
                    console.log(err)
                    failure(err)
                    return
                }
                success(null)
            })
    })
}

exports.deleteItem = (id) => {
    return new Promise((success, failure) => {
        const sql = 'DELETE FROM ITEMS WHERE id=?'
        db.run(sql, [id], (err) => {
            if (err) {
                failure(err)
                return
            }
            success(null)
        })
    })
}