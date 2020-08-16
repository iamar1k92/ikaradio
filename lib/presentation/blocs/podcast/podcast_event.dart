import 'package:base/data/models/podcast.dart';
import 'package:meta/meta.dart';

abstract class PodcastEvent {
  const PodcastEvent();
}

class LoadPodcasts extends PodcastEvent {
  final int categoryId;
  final String search;
  final bool isFeatured;
  final int limit;

  LoadPodcasts({this.categoryId, this.search, this.isFeatured, this.limit});

  @override
  String toString() {
    return 'LoadPodcasts{categoryId: $categoryId, search: $search, isFeatured: $isFeatured, limit: $limit}';
  }
}

class UpdatePodcast extends PodcastEvent {
  final Podcast podcast;

  UpdatePodcast({@required this.podcast});
}
