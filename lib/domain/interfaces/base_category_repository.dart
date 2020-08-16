import 'package:base/data/responses/category_response.dart';

abstract class BaseCategoryRepository {
  Future<CategoryResponse> getCategories();
}
