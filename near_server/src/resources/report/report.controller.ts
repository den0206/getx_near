import {Request, Response} from 'express';
import {commonErrorHandler} from '../../error/custom_error';
import AlreadyReportedError from '../../error/errors/already_reported';
import NotFoundUserError from '../../error/errors/not_find_user';
import {ReportModel, UserModel} from '../../utils/database/models';
import ResponseAPI from '../../utils/interface/response.api';

async function reportUser(req: Request, res: Response) {
  const informer = res.locals.user.userId;

  const {reported, reportedContent, message, post} = req.body;
  try {
    const isFind = await UserModel.findById(reported);
    if (!isFind) throw new NotFoundUserError();

    const isPast = await ReportModel.findOne({informer, reported});

    if (isPast) throw new AlreadyReportedError();

    const report = new ReportModel({
      informer,
      reported,
      reportedContent,
      message,
      post,
    });
    await report.save();

    const count: number = await ReportModel.countDocuments({
      reported: reported,
    });
    if (count > 5) {
      // User を凍結する
      console.log('凍結');
      await UserModel.findByIdAndUpdate(reported, {
        isFrozen: true,
      });
    }

    new ResponseAPI(res, {data: report}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function getReportedCount(req: Request, res: Response) {
  const userId = req.params.userId;

  try {
    const count = await ReportModel.countDocuments({reported: userId} as any);

    new ResponseAPI(res, {data: count.toString()}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

export default {reportUser, getReportedCount};
