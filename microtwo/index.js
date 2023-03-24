const data = require('./db/db')
const express = require('express')
const cors = require('cors')
const bodyParser = require('body-parser')

const app = express()
const port = 3002


app.use(cors())
app.use(bodyParser.json())


app.get('/updates/:id/', (req,res) => {
    data.fetchRevsById(req.params.id)
    .then(revs => res.status(200).json(revs))
    .catch((err) => {
        res.status(500).send(err)
    })
})

app.post('/updates/:id/', cors(), (req,res)=> {
    const rev = {
        id_item : req.params.id,
        content : req.body.content
    }
    console.log(rev)
    data.insertRev(rev)
    .then(() => res.status(201).send(rev))
    .catch((err) => {
        res.status(500).send(err)
    })
})

app.delete('/updates/:id', (req, res) => {
    data.deleteRevs(req.params.id)
        .then(() => res.status(200).send(`Revs for Item ${req.params.id} deleted`))
        .catch((err) => {
            res.status(500).json({ error: `Error deleting Revs for Item: ${err}` })
        })
})

app.listen(port, () => {
    console.log(`Review Service listening on PORT:${port}`)
})