'use strict'
const db = require('./db-init')

exports.fetchRevsById = (id) => { 
    return new Promise((success, failure) => {
        const sql = 'SELECT * FROM REVIEWS WHERE id_item=?'
        db.all(sql, [id], (err, rows) => {
            if (err) {
                failure(err)
                return
            }
            const revs = rows.map((row) => ({
                id: row.id,
                id_item : row.id_item,
                content: row.content
            }))
            success(revs)
        })
    })
}

exports.insertRev = (rev) => {
    return new Promise((success, failure) => {
        const sql = `INSERT INTO 
                        REVIEWS(id, id_item, content)
                            VALUES(?, ?, ?)`
        db.run(sql,
            [
                null,
                rev.id_item,
                rev.content
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

exports.deleteRevs = (id) => {
    return new Promise((success, failure) => {
        const sql = 'DELETE FROM REVIEWS WHERE id_item=?'
        db.run(sql, [id], (err) => {
            if (err) {
                failure(err)
                return
            }
            success(null)
        })
    })
}