const Message = require('../model/message');
const base64 = require('../utils/base64');
const {checkId} = require('../db/database');

async function loadMessage(req, res) {
  const chatRoomId = req.query.chatRoomId;
  const cursor = req.query.cursor;
  const limit = +req.query.limit || 10;

  let query = {chatRoomId: chatRoomId};

  if (cursor) {
    query['_id'] = {
      $lt: base64.decodeToBase64(cursor),
    };
  }
  try {
    let messages = await Message.find(query)
      .sort({_id: -1})
      .limit(limit + 1)
      .populate('userId', '-password');

    const hasNextPage = messages.length > limit;
    messages = hasNextPage ? messages.slice(0, -1) : messages;

    const nextPageCursor = hasNextPage
      ? base64.encodeBase64(messages[messages.length - 1].id)
      : null;

    const data = {
      pageFeeds: messages,
      pageInfo: {
        nextPageCursor: nextPageCursor,
        hasNextPage: hasNextPage,
      },
    };

    res.status(200).json({status: true, data: data});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

async function sendTextMessage(req, res) {
  const userId = req.userData.userId;
  const {chatRoomId, text} = req.body;

  const newMessage = new Message({chatRoomId, text, userId});

  try {
    await newMessage.save();
    res.status(200).json({status: true, data: newMessage});
  } catch (e) {
    res.status(500).json({status: false, message: 'Can not send Message'});
  }
}

async function updateMessage(req, res) {
  const {messageId, readBy} = req.body;

  if (!checkId(messageId))
    return res.status(400).json({status: false, message: 'Invalid id'});

  const value = {readBy};
  try {
    await Message.findByIdAndUpdate(messageId, value);
    res.status(200).json({status: true, data: 'Success,Update Message'});
  } catch (e) {
    res.status(500).json({status: false, message: 'Can not update Message'});
  }
}

async function deleteMessage(req, res) {
  const {messageId} = req.body;

  if (!checkId(messageId))
    return res.status(400).json({status: false, message: 'Invalid id'});

  try {
    const deleteMessage = await Message.findByIdAndDelete(messageId);
    res.status(200).json({status: true, data: deleteMessage});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

module.exports = {loadMessage, sendTextMessage, updateMessage, deleteMessage};
