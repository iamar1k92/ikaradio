import 'package:base/data/models/podcast_category.dart';
import 'package:meta/meta.dart';

abstract class PodcastCategoryState {
  const PodcastCategoryState();
}

class InitialPodcastCategoryState extends PodcastCategoryState {}

class LoadingPodcastCategoryState extends PodcastCategoryState {}

class LoadedPodcastCategoryState extends PodcastCategoryState {
  final List<PodcastCategory> categories;

  LoadedPodcastCategoryState({@required this.categories});
}

class ErrorPodcastCategoryState extends PodcastCategoryState {
  final String error;

  ErrorPodcastCategoryState({@required this.error});
}
