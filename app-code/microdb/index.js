'use strict'
const data = require('./db/db')
const express = require('express')
const { randomBytes } = require('crypto')
const bodyParser = require('body-parser')
const cors = require('cors')
const jwt = require('jsonwebtoken');

async function deleteUpds(id) {
    const response = await fetch(`http://api-two-service.appspace.svc.cluster.local:3002/updates/${id}`, {
        method: 'DELETE'
    })
    if (!response.ok) throw new Error(response.status)
}

const getData = async (owner) => {
    try {
      const response = await fetch(`http://api-usr-service.mainzone.svc.cluster.local:3005/userinfo/${owner}`);
      const data = await response.json();
      return data.color;
    } catch (error) {
      console.error(`Error fetching data for owner ${owner}:`, error);
      return { color: "#202323" };
    }
  }

const app = express()
const port = 3003

app.use(cors())
app.use(bodyParser.json())

app.get('/topics', async (req, res) => {
    try {
      const items = await data.fetchTopics();
  
      const uniqueOwners = [...new Set(items.map(item => item.owner))];
      const colors = await Promise.all(uniqueOwners.map(owner => getData(owner)));
  
      items.forEach(item => {
        const color = colors[uniqueOwners.indexOf(item.owner)] || '#ffffff';
        item.color = color;
      });
  
      res.status(200).json(items);
    } catch (error) {
      res.status(500).send(error);
    }
  });

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

    let par = {}
    const token = req.headers['x-auth-request-access-token'];
    if (token) {
        const decodedToken = jwt.decode(token, { complete: true });
        par = JSON.parse(JSON.stringify(decodedToken))
    }
    let owner = par.payload?.email?par.payload.email:"anon@cloak.app"

    const id = randomBytes(4).toString('hex')

    const { name } = req.body
    let item = {
        id: id,
        name: name
    }
    data.insertTopic(item, owner)
        .then(() => res.status(201).send(item))
        .catch((err) => {
            res.status(500).send(err)
        })
})

app.delete('/topics/:id', (req, res) => {
    
    deleteUpds(req.params.id)
    .then(() => {
        console.log(`Updates for topic ${req.params.id} deleted`)
        data.deleteTopic(req.params.id)
        .then(() => res.status(200).send(`Topic ${req.params.id} deleted`))
        .catch((err) => {
            res.status(500).json({ error: `Error deleting Topic: ${err}` })
        })
    })
    .catch((err) => {
        res.status(500).json({ error: `Error deleting Updates for Topic: ${err}` })
    })

    
})

app.listen(port,
    () => { console.log(`Topic Service listening on PORT:${port}`) }
)

