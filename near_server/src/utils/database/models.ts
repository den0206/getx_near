import {getModelForClass} from '@typegoose/typegoose';
import {commoneSchemaOption} from '../../helper/common';
import {Comment} from '../../resources/comments/comment.model';
import {Message} from '../../resources/messages/message.model';
import {Post} from '../../resources/posts/post.model';
import {Recent} from '../../resources/recents/recent.model';
import {Report} from '../../resources/report/report.model';
import {TempToken} from '../../resources/temp_token/temp_token.model';
import {User} from '../../resources/users/user.model';

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
export const TempTokenModel = getModelForClass(
  TempToken,
  commoneSchemaOption<TempToken>({})
);

export const ReportModel = getModelForClass(
  Report,
  commoneSchemaOption<Report>({})
);
