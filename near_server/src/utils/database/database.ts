import mongoose from 'mongoose';

export async function connectDB() {
  const {MONGO_USER, MONGO_PATH, MONGO_PASSWORD} = process.env;
  const dbUrl = `mongodb+srv://${MONGO_USER}:${MONGO_PASSWORD}@cluster0.0bmco.mongodb.net/${MONGO_PATH}?retryWrites=true&w=majority`;
  // const dbUrl = `mongodb+srv://${MONGO_USER}:${MONGO_PASSWORD}@cluster0.wybhe.mongodb.net/${MONGO_PATH}?retryWrites=true&w=majority`;

  try {
    await mongoose.connect(dbUrl);
    console.log('Success connect DB');
  } catch (e) {
    console.log(e);
  }
}

export function checkMongoId(id: string): boolean {
  return mongoose.isValidObjectId(id);
}
