const Message = require('../model/message');

async function sendTextMessage(req, res) {
  const userId = req.userData.userId;
  const {chatRoomId, text} = req.body;

  const newMessage = new Message({chatRoomId, text, userId});

  console.log(newMessage);

  try {
    await newMessage.save();
    res.status(200).json({status: true, data: newMessage});
  } catch (e) {
    res.status(500).json({status: false, message: 'Can not send Message'});
  }
}

module.exports = {sendTextMessage};
