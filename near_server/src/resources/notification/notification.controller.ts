import {Request, Response} from 'express';
import * as admin from 'firebase-admin';
import mongoose from 'mongoose';
import {commonErrorHandler} from '../../error/custom_error';
import FailSendNotificationError from '../../error/errors/fail_send_notification';
import {RecentModel} from '../../utils/database/models';
import ResponseAPI from '../../utils/interface/response.api';
import {
  MessagingOptions,
  MessagingPayload,
} from './../../../node_modules/firebase-admin/lib/messaging/messaging-api.d';

async function sendNotification(req: Request, res: Response) {
  const {title, body, badge, sound, fcmToken} = req.body;
  try {
    const payload: MessagingPayload = {
      data: {
        sound: sound,
      },
      notification: {
        title: title,
        body: body,
        sound: sound,
        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
      },
    };
    if (badge !== null && payload.data) payload.data.badge = badge.toString();

    const option: MessagingOptions = {
      // Required for background/terminated app state messages on iOS
      contentAvailable: true,
      // Required for background/terminated app state messages on Android
      priority: 'high',
    };
    const sendRequest = await admin
      .messaging()
      .sendToDevice(fcmToken, payload, option);

    if (sendRequest.failureCount) throw new FailSendNotificationError();
    new ResponseAPI(res, {data: sendRequest}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function getBadgeCount(req: Request, res: Response) {
  const userId = req.query.userId as string;

  try {
    const count = await RecentModel.aggregate([
      {$match: {userId: new mongoose.Types.ObjectId(userId)}},
      {$group: {_id: null, counter: {$sum: '$counter'}}},
    ]);

    if (count.length < 1) return new ResponseAPI(res, {data: 0}).excute(200);
    const total = count[0].counter as number;

    new ResponseAPI(res, {data: total}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

export default {sendNotification, getBadgeCount};
