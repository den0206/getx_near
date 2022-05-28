import {
  PutObjectCommand,
  PutObjectCommandInput,
  S3Client,
  DeleteObjectCommand,
  DeleteObjectCommandInput,
} from '@aws-sdk/client-s3';

class AWSClient {
  private s3: S3Client;
  private BUCKET_NAME = process.env.AWS_BUCKET_NAME as string;
  private REGION = process.env.AWS_S3_REGION as string;

  constructor() {
    this.initStorage();
  }

  private initStorage() {
    const ID = process.env.AWS_ID;
    const SECRET = process.env.AWS_SECRET_KEY;

    const client = new S3Client({
      region: this.REGION,
      credentials: {
        accessKeyId: ID as string,
        secretAccessKey: SECRET as string,
      },
    });

    console.log(client);
  }

  public async uploadImage(
    file: Express.Multer.File,
    fileName: string
  ): Promise<string> {
    const params: PutObjectCommandInput = {
      Bucket: this.BUCKET_NAME,
      Key: `${fileName}`,
      Body: file.buffer,
    };
    try {
      const command = new PutObjectCommand(params);
      const response = await this.s3.send(command);
      const fileUrl = this.getUrlFromBucket(params);

      if (response.$metadata.httpStatusCode == 200) {
        return fileUrl;
      } else {
        throw new Error("Can't Update S3");
      }
    } catch (e: any) {
      console.log(e.message);
      throw new Error();
    }
  }

  public async deleteImage(urlString: string) {
    const url = new URL(urlString);
    const filePath = `${url.pathname.slice(1)}`;

    const params: DeleteObjectCommandInput = {
      Bucket: this.BUCKET_NAME,
      Key: filePath,
    };

    try {
      const command = new DeleteObjectCommand(params);
      await this.s3.send(command);
    } catch (e: any) {
      console.log(e.message);
      throw new Error();
    }
  }

  private getUrlFromBucket(params: PutObjectCommandInput) {
    const {Bucket, Key} = params;
    return `https://${Bucket}.s3.${this.REGION}.amazonaws.com/${Key}`;
  }
}

export default AWSClient;
