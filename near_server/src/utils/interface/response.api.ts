import {Response} from 'express';

class ResponseAPI {
  private readonly res: Response;
  private readonly data: any;
  private readonly error: any;

  get status(): boolean {
    return this.data ? true : false;
  }

  constructor(res: Response, {data, error}: {data?: any; error?: any}) {
    this.res = res;
    if (data) this.data = data;
    if (error) this.error = error;
  }

  private get toJson() {
    if (this.data)
      return {
        status: this.status,
        data: this.data,
      };

    if (this.error) return this.parseError;
  }

  private get parseError() {
    const message = this.error.message
      ? this.error.message
      : 'Internal Server Error';

    // message を error に変更
    return {
      status: this.status,
      message: message,
    };
  }

  excute(code: number) {
    this.res.status(code).json(this.toJson);
  }
}

export default ResponseAPI;
