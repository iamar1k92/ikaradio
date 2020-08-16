import 'package:base/data/models/podcast.dart';
import 'package:base/data/models/radio_station.dart';

class SearchResponse {
  final List<RadioStation> radios;
  final List<Podcast> podcasts;
  final String error;

  SearchResponse({this.radios, this.podcasts, this.error});

  SearchResponse.success(json)
      : radios = List<RadioStation>.from((json['radios'] as List).map((x) => RadioStation.fromJson(x))),
        podcasts = List<Podcast>.from((json['podcasts'] as List).map((x) => Podcast.fromJson(x))),
        error = null;

  SearchResponse.error(String error)
      : radios = null,
        podcasts = null,
        error = error;
}
