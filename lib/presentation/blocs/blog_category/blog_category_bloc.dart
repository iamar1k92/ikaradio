import 'dart:async';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/data/repositories/blog_category_repository.dart';
import 'package:base/data/responses/blog_category_response.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class BlogCategoryBloc extends Bloc<BlogCategoryEvent, BlogCategoryState> {
  BlogCategoryRepository _categoryRepository = sl<BlogCategoryRepository>();

  BlogCategoryBloc() : super(InitialBlogCategoryState());

  @override
  Stream<BlogCategoryState> mapEventToState(BlogCategoryEvent event) async* {
    yield LoadingBlogCategoryState();
    if (event is LoadBlogCategories) {
      yield* _mapLoadCategoriesToState();
    }
  }

  Stream<BlogCategoryState> _mapLoadCategoriesToState() async* {
    try {
      BlogCategoryResponse _categoryResponse = await _categoryRepository.getCategories();
      if (_categoryResponse.error == null) {
        yield LoadedBlogCategoryState(categories: _categoryResponse.categories);
      } else {
        yield ErrorBlogCategoryState(error: _categoryResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorBlogCategoryState(error: e.message.toString());
    } catch (e) {
      yield ErrorBlogCategoryState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }
}
