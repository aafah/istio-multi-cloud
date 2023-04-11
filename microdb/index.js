'use strict'
const data = require('./db/db')
const express = require('express')
const { randomBytes } = require('crypto')
const bodyParser = require('body-parser')
const cors = require('cors')
const jwt = require('jsonwebtoken');

async function deleteRev(id) {
    const response = await fetch(`http://api-two-service.appspace.svc.cluster.local:3002/updates/${id}`, {
        method: 'DELETE'
    })
    if (!response.ok) throw new Error(response.status)
}

const app = express()
const port = 3003

app.use(cors())
app.use(bodyParser.json())

app.get('/topics', (req, res) => {

    data.fetchItems()
        .then(items => res.status(200).json(items))
        .catch((err) => {
            res.status(500).send(err)
        })
})

app.get('/debug', (req, res) => {

    let par = ""

    const token = req.headers['x-auth-request-access-token'];
    if (token) {
        const decodedToken = jwt.decode(token, { complete: true });
        par = JSON.stringify(decodedToken)
    }

    res.status(200).json(par)
})

app.post('/topics', (req, res) => {
    const id = randomBytes(4).toString('hex')
    const { name } = req.body
    let item = {
        id: id,
        name: name
    }
    data.insertItem(item)
        .then(() => res.status(201).send(item))
        .catch((err) => {
            res.status(500).send(err)
        })
})

app.delete('/topics/:id', (req, res) => {
    
    deleteRev(req.params.id)
    .then(() => {
        console.log(`Reviews for item ${req.params.id} deleted`)
        data.deleteItem(req.params.id)
        .then(() => res.status(200).send(`Item ${req.params.id} deleted`))
        .catch((err) => {
            res.status(500).json({ error: `Error deleting Item: ${err}` })
        })
    })
    .catch((err) => {
        res.status(500).json({ error: `Error deleting Reviews for Item: ${err}` })
    })

    
})

app.listen(port,
    () => { console.log(`Inventory Service listening on PORT:${port}`) }
)

