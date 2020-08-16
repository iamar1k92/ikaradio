import 'package:base/data/models/radio_station.dart';
import 'package:meta/meta.dart';

abstract class FavoriteRadioState {
  const FavoriteRadioState();
}

class InitialFavoriteRadioState extends FavoriteRadioState {}

class LoadingFavoriteRadioState extends FavoriteRadioState {
  final int radioId;

  LoadingFavoriteRadioState(this.radioId);
}

class ErrorFavoriteRadioState extends FavoriteRadioState {
  final String error;

  ErrorFavoriteRadioState({@required this.error});
}

class LoadedFavoriteRadiosState extends FavoriteRadioState {
  final List<RadioStation> radios;

  LoadedFavoriteRadiosState({@required this.radios});
}

class RadioFavoriteStatusChanged extends FavoriteRadioState {
  final RadioStation radioStation;

  RadioFavoriteStatusChanged({@required this.radioStation});
}
