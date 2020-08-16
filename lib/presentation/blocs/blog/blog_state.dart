import 'package:base/data/models/blog.dart';
import 'package:base/data/models/blog_comment.dart';
import 'package:meta/meta.dart';

abstract class BlogState {}

class InitialBlogState extends BlogState {}

class LoadingBlogState extends BlogState {}

class LoadedBlogState extends BlogState {
  final List<Blog> blogs;

  LoadedBlogState({@required this.blogs});

  @override
  String toString() {
    return 'LoadedBlogState{blogs: $blogs}';
  }
}

class LoadedCommentsState extends BlogState {
  final List<BlogComment> comments;

  LoadedCommentsState({@required this.comments});

  @override
  String toString() {
    return 'LoadedCommentsState{comments: $comments}';
  }
}

class ErrorBlogState extends BlogState {
  final String error;

  ErrorBlogState({@required this.error});
}
