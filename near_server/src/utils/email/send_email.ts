import handlebars from 'handlebars';
import nodemailer, {SendMailOptions} from 'nodemailer';

import * as fs from 'fs';
import * as path from 'path';

export default async function sendEmail({
  email,
  subject,
  payload,
  template,
}: {
  email: string;
  subject: string;
  payload: object;
  template: string;
}) {
  const isDevelop = process.env.NODE_ENV === 'develop';

  const host = isDevelop ? process.env.TRAP_HOST : process.env.SENDGRID_HOST;
  const user = isDevelop
    ? process.env.TRAP_USERNAME
    : process.env.SENDGRID_USERNAME;

  const pass = isDevelop
    ? process.env.TRAP_PASSWORD
    : process.env.SENDGRID_API_KEY;

  const port = isDevelop ? 2525 : 587;
  const from = process.env.EMAIL_FROM;

  try {
    const transport = nodemailer.createTransport({
      host,
      port,
      auth: {user, pass},
    });
    const filePath = path.join(__dirname, template);
    const source = fs.readFileSync(filePath, 'utf8');
    const compiledTemplate = handlebars.compile(source);

    const options: SendMailOptions = {
      from: from,
      to: email,
      subject: subject,
      html: compiledTemplate(payload),
    };

    await transport.sendMail(options);
  } catch (e: any) {
    throw Error(e.message);
  }
}
