import 'package:base/data/responses/blog_response.dart';

abstract class BaseBlogRepository {
  Future<BlogResponse> getBlogs({int categoryId, String search, int limit});

  Future<BlogResponse> comment({int blogId, String comment});

  Future<BlogResponse> deleteComment({int commentId});
}
