import {
  MessagingPayload,
  MessagingOptions,
} from './../../../node_modules/firebase-admin/lib/messaging/messaging-api.d';
import {Request, Response} from 'express';
import * as admin from 'firebase-admin';
import ResponseAPI from '../../utils/interface/response.api';
import {RecentModel} from '../../utils/database/models';
import mongoose from 'mongoose';

async function sendNotification(req: Request, res: Response) {
  const {title, body, badge, fcmToken} = req.body;

  try {
    const payload: MessagingPayload = {
      data: {
        badge: badge,
      },
      notification: {
        title: title,
        body: body,
      },
    };

    const option: MessagingOptions = {
      // Required for background/terminated app state messages on iOS
      contentAvailable: true,
      // Required for background/terminated app state messages on Android
      priority: 'high',
    };
    const sendRequest = await admin
      .messaging()
      .sendToDevice(fcmToken, payload, option);

    console.log(sendRequest);
    if (sendRequest.failureCount)
      return new ResponseAPI(res, {message: '通知を送れませんでした'}).excute(
        400
      );

    new ResponseAPI(res, {data: sendRequest}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
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
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

export default {sendNotification, getBadgeCount};
