const localtunnel = require('localtunnel');

async function connectTunnel(port) {
  const sundomain = process.env.SUB_DOMAIN;
  const tunnel = await localtunnel({
    subdomain: sundomain,
    port: port,
  });
  tunnel.on('close', () => {
    console.log('Close tuunnel');
  });

  console.log(`Open ${tunnel.url}.`);
}

module.exports = {connectTunnel};
