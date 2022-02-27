function postSocket(IO) {
  IO.on('connection', (socket) => {
    console.log('Post SOCKET', socket.id);
    postId = socket.handshake.query.postId;
    socket.join(postId);

    socket.on('new_comment', (com) => {
      IO.to(postId).emit('new_comment', com);
    });

    socket.on('disconnect', () => {
      socket.leave(postId, function (err) {
        if (err) console.log(err);
      });
      console.log('Post Disconnrect');
    });
  });
}

module.exports = postSocket;
