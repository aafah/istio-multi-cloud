'use strict'
const data = require('./db/db')
const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')
const jwt = require('jsonwebtoken');

const app = express()
const port = 3005

app.use(cors())
app.use(bodyParser.json())

app.get('/userinfo', (req, res) => {

    let par = {}

    const token = req.headers['x-auth-request-access-token'];
    if (token) {
        const decodedToken = jwt.decode(token, { complete: true });
        par = JSONE.parse(JSON.stringify(decodedToken))
    }
    let mail = par.email?par.email:"anon@test.app"

    data.fetchData(mail)
        .then(data => {
            let userData = {
                email : mail,
                id : data[0].id,
                color : data[0].color
            }
            res.status(200).json(userData)
        })
        .catch((err) => {
            res.status(500).send(err)
        })
    
})

app.listen(port,
    () => { console.log(`UserInfo service listening on PORT:${port}`) }
)

