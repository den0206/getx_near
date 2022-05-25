import socket from 'socket.io';

export function messageSocket(
  messageIO: socket.Namespace,
  recentIO: socket.Namespace
) {
  messageIO.on('connection', (socket) => {
    console.log('Chat SOCKET', socket.id);
    const q = socket.handshake.query.chatRoomId;
    if (!q) return;

    const chatRoomId = q as string;

    messageIO.socketsJoin(chatRoomId);

    socket.on('new_message', (msg) => {
      messageIO.to(chatRoomId).emit('new_message', msg);
    });

    socket.on('read', (ids) => {
      messageIO.to(chatRoomId).emit('read', ids);
    });

    socket.on('update_recent', (data) => {
      const roomIds = data['userIds'];
      /// socket.io V4
      recentIO.in(roomIds).emit('update', data);
    });

    socket.on('disconnect', () => {
      socket.leave(chatRoomId);
      console.log('Chat Disconnrect');
    });
  });

  messageIO.on('connect_error', (err) => {
    console.log(`connect_error due to ${err.message}`);
  });
}
