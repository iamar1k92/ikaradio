import 'package:base/data/models/radio_station.dart';

class RadioResponse {
  final List<RadioStation> radios;
  final String error;

  RadioResponse({this.radios, this.error});

  RadioResponse.success(json)
      : radios = List<RadioStation>.from((json as List).map((x) => RadioStation.fromJson(x))),
        error = null;

  RadioResponse.error(String error)
      : radios = null,
        error = error;

  @override
  String toString() {
    return 'RadioResponse{radios: $radios, error: $error}';
  }
}
