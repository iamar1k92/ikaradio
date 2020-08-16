import 'package:base/data/responses/blog_category_response.dart';

abstract class BaseBlogCategoryRepository {
  Future<BlogCategoryResponse> getCategories();
}
