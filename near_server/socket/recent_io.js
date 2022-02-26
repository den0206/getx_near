function recentSocket(IO) {
  IO.on('connection', (socket) => {
    console.log('RECENT SOCKET', socket.id);

    userId = socket.handshake.query.userId;
    socket.join(userId);
    console.log(socket.adapter.rooms);

    socket.on('update', (data) => {
      const roomId = data['userId'];
      IO.to(roomId).emit('update', data);
    });

    socket.on('disconnect', () => {
      socket.leave(userId, function (err) {
        if (err) console.log(err);
      });
      console.log('Recent Disconnrect');
    });
  });
}

module.exports = recentSocket;
