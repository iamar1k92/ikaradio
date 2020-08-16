import 'package:base/data/models/radio_station.dart';
import 'package:meta/meta.dart';

abstract class FavoriteRadioEvent{
}

class ToggleRadioFavoriteStatus extends FavoriteRadioEvent {
  final RadioStation radioStation;

  ToggleRadioFavoriteStatus({@required this.radioStation});

}


class LoadFavoriteRadios extends FavoriteRadioEvent {

}
