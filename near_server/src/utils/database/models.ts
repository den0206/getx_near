import {User} from '../../resources/users/user.model';
import {Post} from '../../resources/posts/post.model';
import {Comment} from '../../resources/comments/comment.model';
import {getModelForClass} from '@typegoose/typegoose';
import {commoneSchemaOption} from '../../helper/common';
import {Message} from '../../resources/messages/message.model';
import {Recent} from '../../resources/recents/recent.model';

export const UserModel = getModelForClass(User, commoneSchemaOption<User>({}));

export const PostModel = getModelForClass(Post, commoneSchemaOption<Post>({}));
export const CommentModel = getModelForClass(
  Comment,
  commoneSchemaOption<Comment>({useTimestamp: true})
);

export const MessageModel = getModelForClass(
  Message,
  commoneSchemaOption<Message>({})
);

export const RecentModel = getModelForClass(
  Recent,
  commoneSchemaOption<Recent>({useTimestamp: true})
);
