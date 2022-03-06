const Recent = require('../model/recent');
const base64 = require('../utils/base64');
const {checkId} = require('../db/database');

async function createChatRecet(req, res) {
  const {userId, chatRoomId, withUserId} = req.body;

  const recent = new Recent({chatRoomId, userId, withUserId});

  try {
    await recent.save();
    res.status(200).json({status: true, data: recent});
  } catch (e) {
    res.status(500).json({status: false, message: 'Can not create Recent'});
  }
}

async function updateRecent(req, res) {
  const {recentId, lastMessage, counter} = req.body;

  if (!checkId(recentId))
    return res
      .status(400)
      .json({status: false, message: 'Invalid Chat Room Id'});

  const value = {lastMessage, counter};
  try {
    const updateRecent = await Recent.findByIdAndUpdate(recentId, value, {
      new: true,
    });

    res.status(200).json({status: true, data: updateRecent});
  } catch (e) {
    res.status(500).json({status: false, message: 'Can not update Recents'});
  }
}

async function deleteRecent(req, res) {
  const {recentId} = req.body;
  if (!checkId(recentId))
    return res
      .status(400)
      .json({status: false, message: 'Invalid Chat Room Id'});

  try {
    const del = await Recent.findByIdAndDelete(recentId);
    console.log('Success Delete');
    res.status(200).json({status: true, data: del});
  } catch (e) {
    res.status(500).json({status: false, message: 'Can not delete recent'});
  }
}

async function findByUserId(req, res) {
  const userId = req.userData.userId;

  const cursor = req.query.cursor;
  const limit = +req.query.limit || 10;

  let query = {userId: userId};
  if (cursor) {
    query['_id'] = {
      $lt: base64.decodeToBase64(cursor),
    };
  }
  try {
    let recents = await Recent.find(query)
      .sort({_id: -1})
      .limit(limit + 1)
      .populate(['userId', 'withUserId']);

    const hasNextPage = recents.length > limit;
    recents = hasNextPage ? recents.slice(0, -1) : recents;
    const nextPageCursor = hasNextPage
      ? base64.encodeBase64(recents[recents.length - 1].id)
      : null;

    const data = {
      pageFeeds: recents,
      pageInfo: {
        nextPageCursor: nextPageCursor,
        hasNextPage: hasNextPage,
      },
    };

    res.status(200).json({status: true, data: data});
  } catch (e) {
    res.status(500).json({status: false, message: 'Can not get Recents'});
  }
}

async function findByRoomId(req, res) {
  const chatRoomId = req.query.chatRoomId;

  try {
    const recents = await Recent.find({chatRoomId}).populate([
      'userId',
      'withUserId',
    ]);

    res.status(200).json({status: true, data: recents});
  } catch (e) {
    res.status(500).json({status: false, message: 'Can not get Recents'});
  }
}

async function findByUserAndRoomid(req, res) {
  const userId = req.userData.userId;
  const chatRoomId = req.query.chatRoomId;

  try {
    const findRecent = await Recent.findOne({
      userId: userId,
      chatRoomId: chatRoomId,
    }).populate(['userId', 'withUserId']);

    if (!findRecent)
      return res
        .status(400)
        .json({status: false, message: 'Can not find The Recent'});

    res.status(200).json({status: true, data: findRecent});
  } catch (e) {
    res.status(500).json({status: false, message: 'Can not find Recents'});
  }
}

module.exports = {
  createChatRecet,
  updateRecent,
  deleteRecent,
  findByUserId,
  findByRoomId,
  findByUserAndRoomid,
};
