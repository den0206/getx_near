import cors from 'cors';
import express, {Application} from 'express';
import helmet from 'helmet';
import {connectDB} from './utils/database/database';
import usersRoute from './resources/users/user.route';
import postRoute from './resources/posts/post.route';
import commentRoute from './resources/comments/comment.route';
import messageRoute from './resources/messages/message.route';
import recentRoute from './resources/recents/recent.route';
import tokenRoute from './resources/temp_token/temp_token.route';
import http from 'http';
import {connectIO} from './utils/socket/socket';
import nodeSchedule from 'node-schedule';
import reportRoute from './resources/report/report.route';
import * as serviceAccount from './serviceAccountCredentials.json';
import * as admin from 'firebase-admin';
import notificationRoute from './resources/notification/notification.route';
const get = require('simple-get');

class App {
  public app: Application;
  public port: number;
  public server: http.Server;

  constructor(port: number) {
    this.app = express();
    this.port = port;
    this.server = http.createServer(this.app);

    this.initialiseMiddleware();
    this.initialiseRoutes();
    this.initFirebaseAdmin();

    connectIO(this.server);

    // console.log(listEndpoints(this.app as express.Express));
  }

  private initialiseMiddleware(): void {
    this.app.use(helmet());
    this.app.use(cors());
    this.app.use(express.json());
    this.app.use(express.urlencoded({extended: false}));
  }

  private async initialiseDB(): Promise<void> {
    await connectDB();
  }

  private initialiseRoutes(): void {
    this.app.get('/', (req: express.Request, res: express.Response) => {
      res.status(200).send('Connect Success');
    });

    const apiVer = '/api/v1';
    this.app.use(`${apiVer}/user`, usersRoute);
    this.app.use(`${apiVer}/post`, postRoute);
    this.app.use(`${apiVer}/comment`, commentRoute);
    this.app.use(`${apiVer}/message`, messageRoute);
    this.app.use(`${apiVer}/recent`, recentRoute);
    this.app.use(`${apiVer}/temptoken`, tokenRoute);
    this.app.use(`${apiVer}/report`, reportRoute);
    this.app.use(`${apiVer}/notification`, notificationRoute);
  }

  private initFirebaseAdmin(): void {
    const adminConfig: admin.ServiceAccount = {
      projectId: serviceAccount.project_id,
      privateKey: serviceAccount.private_key,
      clientEmail: serviceAccount.client_email,
    };
    admin.initializeApp({
      credential: admin.credential.cert(adminConfig),
    });

    if (process.env.NODE_ENV == 'production') console.log(adminConfig);
  }
  public listen(): void {
    this.server.listen(this.port, async () => {
      await this.initialiseDB();
      console.log(`APP Listening ${this.port}`);
      this.setSchedule();
    });
  }

  private setSchedule(): void {
    const url = process.env.MAIN_URL;
    if (url) {
      console.log('Set Schedule');
      nodeSchedule.scheduleJob('01,16,25,41,50 * * * *', function () {
        get.concat(url, function (err: any, res: {statusCode: any}, data: any) {
          if (err) throw err;
          console.log(res.statusCode);
        });
      });
    }
  }
}

export default App;
