const express = require('express');
var http = require('http');
const cors = require('cors');
const app = express();
const port = process.env.PORT || 3000;
const mongoSanitize = require('express-mongo-sanitize');
const morgan = require('morgan');
const {connection} = require('./db/database');
const dotenv = require('dotenv');

dotenv.config();
const server = http.createServer(app);

// protect
app.use(mongoSanitize());

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({extended: true}));
app.use(morgan('tiny'));

// connect db
connection();

const userRoute = require('./routes/user_route');
const testPostRoute = require('./routes/test_post_route');

app.get('/', (req, res) => {
  res.status(200).send('Connect Success');
});

const ver = process.env.API_VER;
app.use(`${ver}/user`, userRoute);
app.use(`${ver}/testpost`, testPostRoute);

server.listen(port, () => {
  console.log('server Start', port);
});
