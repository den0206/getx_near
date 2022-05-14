import socket from 'socket.io';

export function postSocket(postIO: socket.Namespace) {
  postIO.on('connection', (socket) => {
    console.log('Post SOCKET', socket.id);
    const q = socket.handshake.query.postId;
    if (!q) return;
    const postId = q as string;

    postIO.socketsJoin(postId);
    // socket.join(postId);
    socket.on('new_comment', (com) => {
      postIO.to(postId).emit('new_comment', com);
    });

    socket.on('disconnect', () => {
      socket.leave(postId);
      console.log('Post Disconnrect');
    });
  });
}
