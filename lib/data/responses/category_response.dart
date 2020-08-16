import 'package:base/data/models/category.dart';

class CategoryResponse {
  final List<Category> categories;
  final String error;

  CategoryResponse({this.categories, this.error});

  CategoryResponse.success(json)
      : categories = List<Category>.from((json as List).map((x) => Category.fromJson(x))),
        error = null;

  CategoryResponse.error(String error)
      : categories = null,
        error = error;

  @override
  String toString() {
    return 'CategoryResponse{categories: $categories, error: $error}';
  }
}
