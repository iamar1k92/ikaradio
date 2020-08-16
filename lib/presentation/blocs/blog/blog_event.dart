import 'package:meta/meta.dart';

abstract class BlogEvent {
  const BlogEvent();
}

class LoadBlogs extends BlogEvent {
  final int categoryId;
  final String search;
  final int limit;

  LoadBlogs({this.categoryId, this.search, this.limit});

  @override
  String toString() {
    return 'LoadBlogs{categoryId: $categoryId, search: $search,  limit: $limit}';
  }
}

class Comment extends BlogEvent {
  final int blogId;
  final String comment;

  Comment({@required this.blogId, @required this.comment});

  @override
  String toString() {
    return 'Comment{blogId: $blogId, comment: $comment}';
  }
}

class DeleteComment extends BlogEvent {
  final int commentId;

  DeleteComment({@required this.commentId});

  @override
  String toString() {
    return 'DeleteComment{commentId: $commentId}';
  }
}
