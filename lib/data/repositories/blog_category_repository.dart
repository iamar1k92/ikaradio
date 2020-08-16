import 'package:base/data/providers/blog_category_api_provider.dart';
import 'package:base/data/responses/blog_category_response.dart';
import 'package:base/domain/interfaces/base_blog_category_repository.dart';
import 'package:base/injection_container.dart';

class BlogCategoryRepository implements BaseBlogCategoryRepository {
  final BlogCategoryApiProvider _blogCategoryApiProvider = sl<BlogCategoryApiProvider>();

  @override
  Future<BlogCategoryResponse> getCategories() async {
    return await _blogCategoryApiProvider.getCategories();
  }
}
