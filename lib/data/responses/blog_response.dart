import 'package:base/data/models/blog.dart';
import 'package:base/data/models/blog_comment.dart';

class BlogResponse {
  final List<Blog> blogs;
  final List<BlogComment> comments;
  final String error;

  BlogResponse({this.blogs, this.comments, this.error});

  BlogResponse.success(json)
      : blogs = List<Blog>.from((json as List).map((x) => Blog.fromJson(x))),
        comments = null,
        error = null;

  BlogResponse.successComments(json)
      : blogs = null,
        comments = List<BlogComment>.from((json as List).map((x) => BlogComment.fromJson(x))),
        error = null;

  BlogResponse.error(String error)
      : blogs = null,
        comments = null,
        error = error;

  @override
  String toString() {
    return 'BlogResponse{blogs: $blogs, comments: $comments, error: $error}';
  }
}
