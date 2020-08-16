import 'package:base/data/models/radio_station.dart';
import 'package:base/data/responses/radio_response.dart';

abstract class BaseRadioRepository {
  Future<RadioResponse> getRadios({int categoryId, String search, bool isFeatured,int limit});

  Future<RadioResponse> addFavoriteRadio(RadioStation radio);

  Future<RadioResponse> removeFavoriteRadio(RadioStation radio);

  Future<RadioResponse> getFavoriteRadios();
}
