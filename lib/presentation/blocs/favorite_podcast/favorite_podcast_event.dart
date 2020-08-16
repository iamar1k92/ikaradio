import 'package:base/data/models/podcast.dart';
import 'package:meta/meta.dart';

abstract class FavoritePodcastEvent{
}

class TogglePodcastFavoriteStatus extends FavoritePodcastEvent {
  final Podcast podcast;

  TogglePodcastFavoriteStatus({@required this.podcast});

}


class LoadFavoritePodcasts extends FavoritePodcastEvent {

}
