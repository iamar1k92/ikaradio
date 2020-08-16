import 'package:base/data/models/blog_category.dart';
import 'package:meta/meta.dart';

abstract class BlogCategoryState {
  const BlogCategoryState();
}

class InitialBlogCategoryState extends BlogCategoryState {}

class LoadingBlogCategoryState extends BlogCategoryState {}

class LoadedBlogCategoryState extends BlogCategoryState {
  final List<BlogCategory> categories;

  LoadedBlogCategoryState({@required this.categories});
}

class ErrorBlogCategoryState extends BlogCategoryState {
  final String error;

  ErrorBlogCategoryState({@required this.error});
}
