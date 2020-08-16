import 'package:base/data/models/podcast.dart';
import 'package:meta/meta.dart';

abstract class FavoritePodcastState {
  const FavoritePodcastState();
}

class InitialFavoritePodcastState extends FavoritePodcastState {}

class LoadingFavoritePodcastState extends FavoritePodcastState {
  final int podcastId;

  LoadingFavoritePodcastState(this.podcastId);
}

class ErrorFavoritePodcastState extends FavoritePodcastState {
  final String error;

  ErrorFavoritePodcastState({@required this.error});
}

class LoadedFavoritePodcastsState extends FavoritePodcastState {
  final List<Podcast> podcasts;

  LoadedFavoritePodcastsState({@required this.podcasts});
}

class PodcastFavoriteStatusChanged extends FavoritePodcastState {
  final Podcast podcast;

  PodcastFavoriteStatusChanged({@required this.podcast});
}
