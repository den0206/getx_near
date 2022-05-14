import http from 'http';
import socket from 'socket.io';
import {messageSocket} from './message_io';
import {recentSocket} from './recent_io';
import {postSocket} from './post_io';

export function connectIO(server: http.Server) {
  const local = process.env.LOCAL;
  const io = new socket.Server(server, {cors: {origin: local}});

  var recentIO = io.of('/recents');
  var messageIO = io.of('/message');
  var postIO = io.of('/post');

  recentSocket(recentIO);
  messageSocket(messageIO, recentIO);
  postSocket(postIO);
}
