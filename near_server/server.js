const express = require('express');
var http = require('http');
const cors = require('cors');
const app = express();
const port = process.env.PORT || 3000;
const helmet = require('helmet');
const mongoSanitize = require('express-mongo-sanitize');
const morgan = require('morgan');
const {connection} = require('./db/database');
const dotenv = require('dotenv');
const checkAPIKey = require('./middleware/check_api');

dotenv.config();
const server = http.createServer(app);

// protect
app.use(mongoSanitize());
app.use(helmet());

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({extended: true}));
app.use(morgan('tiny'));

// connect db
connection();

const userRoute = require('./routes/user_route');
const postRoutes = require('./routes/post_routes');
const commentRoute = require('./routes/comment_route');
const recentRoute = require('./routes/recent_route');
const messageRoute = require('./routes/message_route');

app.get('/', (req, res) => {
  res.status(200).send('Connect Success');
});

const ver = process.env.API_VER;
app.all(`${ver}/*`, checkAPIKey);
app.use(`${ver}/user`, userRoute);
app.use(`${ver}/post`, postRoutes);
app.use(`${ver}/comment`, commentRoute);
app.use(`${ver}/recent`, recentRoute);
app.use(`${ver}/message`, messageRoute);

server.listen(port, () => {
  console.log('server Start', port);
});
