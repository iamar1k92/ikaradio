import 'package:base/data/models/category.dart';
import 'package:meta/meta.dart';

abstract class CategoryState {
  const CategoryState();
}

class InitialCategoryState extends CategoryState {}

class LoadingCategoryState extends CategoryState {}

class LoadedCategoryState extends CategoryState {
  final List<Category> categories;

  LoadedCategoryState({@required this.categories});
}

class ErrorCategoryState extends CategoryState {
  final String error;

  ErrorCategoryState({@required this.error});
}
