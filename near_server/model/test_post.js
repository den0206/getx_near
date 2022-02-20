const mongoose = require(`mongoose`);
const GeoJSON = require(`mongoose-geojson-schema`);

const testSampleSchema = mongoose.Schema({
  title: {type: String},
  content: {type: String, required: true},
  location: {
    type: {
      type: String,
      enum: ['Point'],
      required: true,
    },
    coordinates: {
      type: [Number],
      required: true,
      // index: `2dsphere`,
    },
  },
  createdAt: {
    type: Date,
    default: Date.now,
    expires: 3600,
  },
});

testSampleSchema.index({location: '2dsphere'});
testSampleSchema.virtual('id').get(function () {
  if (this._id) return this._id.toHexString();
});

testSampleSchema.set('toJSON', {
  virtuals: true,
});

const TestPost = mongoose.model('TestPost', testSampleSchema);
module.exports = TestPost;
