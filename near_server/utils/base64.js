function encodeBase64(data) {
  return Buffer.from(data).toString('base64');
}

function decodeToBase64(data) {
  return Buffer.from(data, 'base64').toString('ascii');
}

module.exports = {encodeBase64, decodeToBase64};
