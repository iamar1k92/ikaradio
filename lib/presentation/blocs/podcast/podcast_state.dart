import 'package:base/data/models/podcast.dart';
import 'package:meta/meta.dart';

abstract class PodcastState {}

class InitialPodcastState extends PodcastState {}

class LoadingPodcastState extends PodcastState {}

class LoadedPodcastState extends PodcastState {
  final List<Podcast> podcasts;

  LoadedPodcastState({@required this.podcasts});

  @override
  String toString() {
    return 'LoadedPodcastState{podcasts: $podcasts}';
  }
}

class ErrorPodcastState extends PodcastState {
  final String error;

  ErrorPodcastState({@required this.error});
}
