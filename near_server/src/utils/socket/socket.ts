import http from 'http';
import socket from 'socket.io';
import {messageSocket} from './message_io';
import {postSocket} from './post_io';
import {recentSocket} from './recent_io';

export function connectIO(server: http.Server) {
  const local = process.env.LOCAL as string;
  const lc = process.env.LOLACTUNNEL as string;

  const io = new socket.Server(server, {cors: {origin: [local, lc]}});

  const recentIO = io.of('/recents');
  const messageIO = io.of('/message');
  const postIO = io.of('/post');

  recentSocket(recentIO);
  messageSocket(messageIO, recentIO);
  postSocket(postIO);
}
