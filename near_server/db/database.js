const mongoose = require('mongoose');

async function connection() {
  const name = process.env.DB_USER_NAME;
  const dbName = process.env.DB_NAME;
  const password = process.env.DB_PASS;

  try {
    const dbUrl = `mongodb+srv://${name}:${password}@cluster0.0bmco.mongodb.net/${dbName}?retryWrites=true&w=majority`;
    await mongoose.connect(dbUrl, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      dbName: dbName,
    });

    console.log('Success DB', dbName);
  } catch (e) {
    console.log(e);
  }
}

function checkId(id) {
  return mongoose.isValidObjectId(id);
}

module.exports = {connection, checkId};
