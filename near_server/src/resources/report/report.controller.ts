import {Request, Response} from 'express';
import {UserModel, ReportModel} from '../../utils/database/models';
import ResponseAPI from '../../utils/interface/response.api';

async function reportUser(req: Request, res: Response) {
  const informer = res.locals.user.userId;

  const {reported, reportedContent, message, post} = req.body;
  try {
    const isFind = await UserModel.findById(reported);
    if (!isFind)
      return new ResponseAPI(res, {message: 'No Exist User'}).excute(400);

    const isPast = await ReportModel.findOne({informer, reported});
    if (isPast)
      return new ResponseAPI(res, {
        message: '過去に通報済みのユーザーです',
      }).excute(400);

    const report = new ReportModel({
      informer,
      reported,
      reportedContent,
      message,
      post,
    });
    await report.save();
    new ResponseAPI(res, {data: report}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function getReportedCount(req: Request, res: Response) {
  const userId = req.params.userId;

  try {
    const count = await ReportModel.countDocuments({reported: userId});

    new ResponseAPI(res, {data: count.toString()}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

export default {reportUser, getReportedCount};
