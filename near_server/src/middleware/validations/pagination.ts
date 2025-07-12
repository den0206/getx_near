import {object, string, TypeOf} from 'zod';

export const pagingQuery = {
  query: object({
    cursor: string().optional(),
    limit: string().optional(),
  }),
};

export type PagingQuery = TypeOf<typeof pagingQuery.query>;

export const pagingPostIdQuery = {
  query: object({
    postId: string({message: 'require Post Id'}),
    cursor: string().optional(),
    limit: string().optional(),
  }),
};

export type PagingWithPostIdQuery = TypeOf<typeof pagingPostIdQuery.query>;

export const pagingChatIdQuery = {
  query: object({
    chatRoomId: string({message: 'require Chat Id'}),
    cursor: string().optional(),
    limit: string().optional(),
  }),
};

export type PagingWithChatIdQuery = TypeOf<typeof pagingChatIdQuery.query>;
