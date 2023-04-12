const data = require('./db/db')
const express = require('express')
const cors = require('cors')
const bodyParser = require('body-parser')
const jwt = require('jsonwebtoken');

const app = express()
const port = 3002


app.use(cors())
app.use(bodyParser.json())

async function getTime() {
    // http://worldtimeapi.org/api/timezone/Europe/Rome
    const response = await fetch(`https://timeapi.io/api/Time/current/zone?timeZone=Europe/Rome`, {
        method: 'GET'
    })
    if (!response.ok) throw new Error(response.status)
    const json = await response.json()
    return JSON.stringify(json)
}


app.get('/updates/:id/', (req, res) => {
    data.fetchUpdsById(req.params.id)
        .then(revs => res.status(200).json(revs))
        .catch((err) => {
            res.status(500).send(err)
        })
})

app.post('/updates/:id/', cors(), async (req, res) => {

    let par = {}
    const token = req.headers['x-auth-request-access-token'];
    if (token) {
        const decodedToken = jwt.decode(token, { complete: true });
        par = JSON.parse(JSON.stringify(decodedToken))
    }
    let owner = par.payload.email?par.payload.email:"anon@test.app"

    const upd = {
        id_item: req.params.id,
        content: req.body.content,
        owner: owner,
        timestamp: "timeErr"
    }
    try {
        let time = await getTime()
        time = JSON.parse(time)
        if (time.dateTime != null) {
            upd.timestamp = time.dateTime.slice(0, 16)
            console.log (upd)
        }
    }catch {}
    
    data.insertUpd(upd)
        .then(() => res.status(201).send(upd))
        .catch((err) => {
            res.status(500).send(err)
        })

})

app.delete('/updates/:id', (req, res) => {
    data.deleteUpds(req.params.id)
        .then(() => res.status(200).send(`Updates for Item ${req.params.id} deleted`))
        .catch((err) => {
            res.status(500).json({ error: `Error deleting Updates for Item: ${err}` })
        })
})

app.listen(port, () => {
    console.log(`Updates Service listening on PORT:${port}`)
})