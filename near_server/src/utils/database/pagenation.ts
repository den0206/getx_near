import {Model} from 'mongoose';
import Base64 from '../../helper/base64';

export async function usePagenation<T>({
  model,
  limit,
  cursor,
  populate,
  exclued,
  specific,
}: {
  model: Model<T>;
  limit: number;
  cursor?: string;
  populate?: string;
  exclued?: string | string[];
  specific?: {};
}) {
  let query = {};

  if (cursor) {
    query = {
      _id: {
        $lt: Base64.decodeToBase64(cursor),
      },
    };
  }

  if (specific) {
    query = {...query, ...specific};
  }

  let array;

  if (populate) {
    array = await model
      .find(query)
      .sort({_id: -1})
      .limit(limit + 1)
      .populate(populate, exclued);
  } else {
    array = await model
      .find(query)
      .sort({_id: -1})
      .limit(limit + 1);
  }

  const hasNextPage = array.length > limit;
  array = hasNextPage ? array.slice(0, -1) : array;
  const nextPageCursor = hasNextPage
    ? Base64.encodeBase64((array[array.length - 1] as any)._id.toString())
    : null;

  const data = {
    pageFeeds: array,
    pageInfo: {nextPageCursor, hasNextPage},
  };

  return data;
}
