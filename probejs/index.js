const express = require('express');

const app = express();
const port = 3001;

app.get('/', (req, res) => {
  res.send('Probe GET');
});

app.listen(port, () => {
  console.log(`Probe listening at port ${port}`);
});