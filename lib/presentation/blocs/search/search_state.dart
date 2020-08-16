import 'package:base/data/models/podcast.dart';
import 'package:base/data/models/radio_station.dart';
import 'package:meta/meta.dart';

abstract class SearchState {}

class InitialSearchState extends SearchState {}

class LoadingSearchState extends SearchState {}

class SearchResultState extends SearchState {
  final List<RadioStation> radios;
  final List<Podcast> podcasts;

  SearchResultState({@required this.radios, @required this.podcasts});
}

class ErrorSearchState extends SearchState {
  final String error;

  ErrorSearchState({@required this.error});
}
