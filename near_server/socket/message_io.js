//https://stackoverflow.com/questions/50015017/socket-io-rooms-difference-between-to-and-in
// ".to" and ".in" same

function messageScoket(messageIO, recentIO) {
  messageIO.on('connection', (socket) => {
    console.log('Chat SOCKET', socket.id);

    chatRoomId = socket.handshake.query.chatRoomId;
    socket.join(chatRoomId);

    socket.on('new_message', (msg) => {
      messageIO.to(chatRoomId).emit('new_message', msg);
    });

    socket.on('read', (ids) => {
      messageIO.to(chatRoomId).emit('read', ids);
    });

    socket.on('update_recent', (data) => {
      roomIds = data['userIds'];
      roomIds.forEach(function (room) {
        recentIO.to(room).emit('update', data);
      });
    });

    socket.on('disconnect', () => {
      socket.leave(chatRoomId, function (err) {
        if (err) console.log(err);
      });
      console.log('Chat Disconnrect');
    });
  });
}

module.exports = messageScoket;
