import 'dart:async';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/data/repositories/podcast_category_repository.dart';
import 'package:base/data/responses/podcast_category_response.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class PodcastCategoryBloc extends Bloc<PodcastCategoryEvent, PodcastCategoryState> {
  PodcastCategoryRepository _categoryRepository = sl<PodcastCategoryRepository>();

  PodcastCategoryBloc() : super(InitialPodcastCategoryState());

  @override
  Stream<PodcastCategoryState> mapEventToState(PodcastCategoryEvent event) async* {
    yield LoadingPodcastCategoryState();
    if (event is LoadPodcastCategories) {
      yield* _mapLoadCategoriesToState();
    }
  }

  Stream<PodcastCategoryState> _mapLoadCategoriesToState() async* {
    try {
      PodcastCategoryResponse _categoryResponse = await _categoryRepository.getCategories();
      if (_categoryResponse.error == null) {
        yield LoadedPodcastCategoryState(categories: _categoryResponse.categories);
      } else {
        yield ErrorPodcastCategoryState(error: _categoryResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorPodcastCategoryState(error: e.message.toString());
    } catch (e) {

      yield ErrorPodcastCategoryState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }
}
