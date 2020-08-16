import 'dart:async';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/data/repositories/category_repository.dart';
import 'package:base/data/responses/category_response.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryRepository _categoryRepository = sl<CategoryRepository>();

  CategoryBloc() : super(InitialCategoryState());

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    yield LoadingCategoryState();
    if (event is LoadCategories) {
      yield* _mapLoadCategoriesToState();
    }
  }

  Stream<CategoryState> _mapLoadCategoriesToState() async* {
    try {
      CategoryResponse _categoryResponse = await _categoryRepository.getCategories();
      if (_categoryResponse.error == null) {
        yield LoadedCategoryState(categories: _categoryResponse.categories);
      } else {
        yield ErrorCategoryState(error: _categoryResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorCategoryState(error: e.message.toString());
    } catch (e) {

      yield ErrorCategoryState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }
}
