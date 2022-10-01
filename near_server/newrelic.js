require('dotenv').config();

const license_key = process.env.NEWRELIC_KEY;

if (!license_key) {
  console.log('New Relic Key Not Found');
  return;
}

console.log('New Relic Set');
('use strict');
exports.config = {
  app_name: ['help'],
  license_key: license_key,
  logging: {
    level: 'info',
  },
  allow_all_headers: true,
  application_logging: {
    forwarding: {
      enabled: true,
    },
  },
  attributes: {
    exclude: [
      'request.headers.cookie',
      'request.headers.authorization',
      'request.headers.proxyAuthorization',
      'request.headers.setCookie*',
      'request.headers.x*',
      'response.headers.cookie',
      'response.headers.authorization',
      'response.headers.proxyAuthorization',
      'response.headers.setCookie*',
      'response.headers.x*',
    ],
  },
};
