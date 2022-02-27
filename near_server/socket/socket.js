var socket = require('socket.io');
const recentsSocket = require('./recent_io');
const messageSocket = require('./message_io');
const postSocket = require('./post_io');

function connectIO(server) {
  const local = process.env.LOCAL;
  const io = socket(server, {cors: {origin: [local]}});

  var recentIO = io.of('/recents');
  var messageIO = io.of('/message');
  var postIO = io.of('/post');

  recentsSocket(recentIO);
  messageSocket(messageIO, recentIO);
  postSocket(postIO);
}

module.exports = connectIO;
