import 'package:base/data/providers/blog_api_provider.dart';
import 'package:base/data/responses/blog_response.dart';
import 'package:base/domain/interfaces/base_blog_repository.dart';
import 'package:base/injection_container.dart';
import 'package:meta/meta.dart';

class BlogRepository implements BaseBlogRepository {
  final BlogApiProvider _blogApiProvider = sl<BlogApiProvider>();

  @override
  Future<BlogResponse> getBlogs({int categoryId, String search, int limit}) async {
    return await _blogApiProvider.getBlogs(categoryId: categoryId, search: search, limit: limit);
  }

  @override
  Future<BlogResponse> comment({@required int blogId, @required String comment}) async {
    return await _blogApiProvider.comment(blogId: blogId, comment: comment);
  }

  @override
  Future<BlogResponse> deleteComment({@required int commentId}) async {
    return await _blogApiProvider.deleteComment(commentId: commentId);
  }
}
