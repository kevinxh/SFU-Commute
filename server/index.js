var express = require('express');
var app = express();

app.get('/', function (req, res) {
  res.send('Initialize SFU-Commute backend server!');
});

app.listen(3000, function () {
  console.log('Initialize SFU-Commute backend server!');
});
