import 'package:base/data/models/podcast.dart';
import 'package:base/data/models/radio_station.dart';
import 'package:meta/meta.dart';

abstract class SearchEvent {
  const SearchEvent();
}

class Search extends SearchEvent {
  final String query;

  Search({@required this.query});
}

class UpdateRadio extends SearchEvent {
  final RadioStation radioStation;

  UpdateRadio({@required this.radioStation});
}

class UpdatePodcast extends SearchEvent {
  final Podcast podcast;

  UpdatePodcast({@required this.podcast});
}
