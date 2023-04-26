'use strict'
const db = require('./db-init')

exports.fetchTopics = () => { //Ottiene TOPICS
    return new Promise((success, failure) => {
        const sql = 'SELECT * FROM TOPICS'
        db.all(sql, [], (err, rows) => {
            if (err) {
                failure(err)
                return
            }
            const TOPICS = rows.map((row) => ({
                id: row.id,
                name: row.name,
                owner: row.owner
            }))
            success(TOPICS)
        })
    })
}

exports.insertTopic = (item, owner) => {
    return new Promise((success, failure) => {
        const sql = `INSERT INTO 
                        TOPICS(id, name, owner)
                            VALUES(?, ?, ?)`
        db.run(sql,
            [
                item.id,
                item.name,
                owner
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

exports.deleteTopic = (id) => {
    return new Promise((success, failure) => {
        const sql = 'DELETE FROM TOPICS WHERE id=?'
        db.run(sql, [id], (err) => {
            if (err) {
                failure(err)
                return
            }
            success(null)
        })
    })
}