export default class Base64 {
  static encodeBase64(data: any) {
    return Buffer.from(data).toString('base64');
  }

  static decodeToBase64(data: any) {
    return Buffer.from(data, 'base64').toString('ascii');
  }
}
