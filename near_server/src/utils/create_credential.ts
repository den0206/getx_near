import 'dotenv/config';
import * as fs from 'fs';

const CREDENTIAL_PATH = 'src/serviceAccountCredentials.json';

// 暗号化 base64 serviceAccountCredentials.json > encode-credential.txt
function createCredential() {
  try {
    const credentialFile = fs.readFileSync(CREDENTIAL_PATH);
    console.log('Credential_fileは既にあります');
    return;
  } catch (e) {
    const encode = process.env.CREDENTIAL_KEY;

    if (!encode) return;
    const decode = Buffer.from(encode, 'base64').toString();

    fs.writeFile(CREDENTIAL_PATH, decode, (err) => {
      if (err) return console.error(err);
      console.log('Credential_fileを作成しました', CREDENTIAL_PATH);
    });
  }
}

createCredential();
