import 'dotenv/config';
import 'newrelic';
import App from './app';

const app = new App(Number(process.env.PORT));

app.listen();
