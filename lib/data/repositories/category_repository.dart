import 'package:base/data/providers/category_api_provider.dart';
import 'package:base/data/responses/category_response.dart';
import 'package:base/domain/interfaces/base_category_repository.dart';
import 'package:base/injection_container.dart';

class CategoryRepository implements BaseCategoryRepository {
  final CategoryApiProvider _categoryApiProvider = sl<CategoryApiProvider>();

  @override
  Future<CategoryResponse> getCategories() async {
    return await _categoryApiProvider.getCategories();
  }
}
