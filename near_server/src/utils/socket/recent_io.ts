import socket from 'socket.io';

export function recentSocket(recentIO: socket.Namespace) {
  recentIO.on('connection', (socket) => {
    const q = socket.handshake.query.userId;
    if (!q) return;
    const userId = q as string;
    console.log('Recent user id', userId);
    // recentIO.socketsJoin(userId);
    socket.join(userId);

    console.log(recentIO.adapter.rooms.size);
    socket.on('update', (data) => {
      const roomId = data['userId'];
      recentIO.to(roomId).emit('update', data);
    });

    socket.on('disconnect', () => {
      socket.leave(userId);
      console.log('Recent Disconnrect');
    });
  });

  recentIO.on('connect_error', (err) => {
    console.log(`connect_error due to ${err.message}`);
  });
}
