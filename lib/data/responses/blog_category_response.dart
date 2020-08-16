import 'package:base/data/models/blog_category.dart';

class BlogCategoryResponse {
  final List<BlogCategory> categories;
  final String error;

  BlogCategoryResponse({this.categories, this.error});

  BlogCategoryResponse.success(json)
      : categories = List<BlogCategory>.from((json as List).map((x) => BlogCategory.fromJson(x))),
        error = null;

  BlogCategoryResponse.error(String error)
      : categories = null,
        error = error;

  @override
  String toString() {
    return 'CategoryResponse{categories: $categories, error: $error}';
  }
}
