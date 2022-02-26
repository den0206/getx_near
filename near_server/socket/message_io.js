function messageScoket(IO) {
  IO.on('connection', (socket) => {
    console.log('Chat SOCKET', socket.id);

    chatRoomId = socket.handshake.query.chatRoomId;
    socket.join(chatRoomId);
    console.log(socket.adapter.rooms);

    socket.on('disconnect', () => {
      socket.leave(chatRoomId, function (err) {
        if (err) console.log(err);
      });
      console.log('Chat Disconnrect');
    });
  });
}

module.exports = messageScoket;
