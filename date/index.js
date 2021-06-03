const express = require('express');

const port = 3000;

const app = express();
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

const getDate = () => {
  return `${new Date()}`;
}

app.get('/', (req, res) => {
  const date = getDate();
  console.log('GET', date);
  // res.send(`GET request`);
  res.send(`GET request ; date = ${date}`);
});

app.post('/', (req, res) => {
  const date = getDate();
  const body = JSON.stringify(req.body);
  console.log('POST', date);
  // res.send(`POST request`);
  res.send(`POST request ; date = ${date}\n\nBODY:\n${body}`);
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
