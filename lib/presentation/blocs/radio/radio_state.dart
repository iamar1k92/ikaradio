import 'package:base/data/models/radio_station.dart';
import 'package:meta/meta.dart';

abstract class RadioState {}

class InitialRadioState extends RadioState {}

class LoadingRadioState extends RadioState {}

class LoadedRadioState extends RadioState {
  final List<RadioStation> radios;

  LoadedRadioState({@required this.radios});

  @override
  String toString() {
    return 'LoadedRadioState{radios: $radios}';
  }
}

class ErrorRadioState extends RadioState {
  final String error;

  ErrorRadioState({@required this.error});
}
