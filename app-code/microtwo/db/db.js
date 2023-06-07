'use strict'
const db = require('./db-init')

exports.fetchUpdsById = (id) => { 
    return new Promise((success, failure) => {
        const sql = 'SELECT * FROM UPDATES WHERE id_item=?'
        db.all(sql, [id], (err, rows) => {
            if (err) {
                failure(err)
                return
            }
            const revs = rows.map((row) => ({
                id: row.id,
                id_item : row.id_item,
                content: row.content,
                owner: row.owner,
                timestamp: row.timestamp
            }))
            success(revs)
        })
    })
}

exports.insertUpd = (upd) => {
    return new Promise((success, failure) => {
        const sql = `INSERT INTO 
                        UPDATES(id, id_item, content, owner, timestamp)
                            VALUES(?, ?, ?, ?, ?)`
        db.run(sql,
            [
                null,
                upd.id_item,
                upd.content,
                upd.owner,
                upd.timestamp
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

exports.deleteUpds = (id) => {
    return new Promise((success, failure) => {
        const sql = 'DELETE FROM UPDATES WHERE id_item=?'
        db.run(sql, [id], (err) => {
            if (err) {
                failure(err)
                return
            }
            success(null)
        })
    })
}