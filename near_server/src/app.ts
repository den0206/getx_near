import cors from 'cors';
import express, {Application} from 'express';
import helmet from 'helmet';
import {connectDB} from './utils/database/database';
import usersRoute from './resources/users/user.route';
import postRoute from './resources/posts/post.route';
import commentRoute from './resources/comments/comment.route';
import messageRoute from './resources/messages/message.route';
import recentRoute from './resources/recents/recent.route';
import http from 'http';
import {connectIO} from './utils/socket/socket';

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
    const apiVer = '/api/v1';
    this.app.use(`${apiVer}/user`, usersRoute);
    this.app.use(`${apiVer}/post`, postRoute);
    this.app.use(`${apiVer}/comment`, commentRoute);
    this.app.use(`${apiVer}/message`, messageRoute);
    this.app.use(`${apiVer}/recent`, recentRoute);
  }

  public listen(): void {
    this.server.listen(this.port, async () => {
      await this.initialiseDB();
      console.log(`APP Listening ${this.port}`);
    });
  }
}

export default App;
