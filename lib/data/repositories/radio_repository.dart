import 'package:base/core/local/database_helper.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/data/models/radio_station.dart';
import 'package:base/data/providers/radio_api_provider.dart';
import 'package:base/data/responses/radio_response.dart';
import 'package:base/domain/interfaces/base_radio_repository.dart';
import 'package:base/injection_container.dart';

class RadioRepository implements BaseRadioRepository {
  final RadioApiProvider _radioApiProvider = sl<RadioApiProvider>();
  final SharedPreferenceHelper _sharedPreferenceHelper = sl<SharedPreferenceHelper>();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<RadioResponse> getRadios({int categoryId, String search, bool isFeatured, int limit}) async {
    RadioResponse _radioResponse = await _radioApiProvider.getRadios(categoryId: categoryId, search: search, isFeatured: isFeatured, limit: limit);
    if (_radioResponse.error == null) {
      if (!await _sharedPreferenceHelper.isLoggedIn()) {
        await Future.wait(_radioResponse.radios.map((radioStation) async {
          radioStation.isFavorite = await _databaseHelper.exist(RadioStation.table, radioStation.id);
          return radioStation;
        }).toList());
      }
    }

    return _radioResponse;
  }

  @override
  Future<RadioResponse> getFavoriteRadios() async {
    if (await _sharedPreferenceHelper.isLoggedIn()) {
      return await _radioApiProvider.getFavoriteRadios();
    } else {
      List<RadioStation> _radioList = await RadioStation().getList();
      return RadioResponse(radios: _radioList);
    }
  }

  @override
  Future<RadioResponse> addFavoriteRadio(RadioStation radioStation) async {
    if (await _sharedPreferenceHelper.isLoggedIn()) {
      return await _radioApiProvider.addFavoriteRadio(radioStation);
    } else {
      await _databaseHelper.insert(RadioStation.table, radioStation);
      return RadioResponse();
    }
  }

  @override
  Future<RadioResponse> removeFavoriteRadio(RadioStation radio) async {
    if (await _sharedPreferenceHelper.isLoggedIn()) {
      return await _radioApiProvider.removeFavoriteRadio(radio);
    } else {
      await _databaseHelper.delete(RadioStation.table, radio.id);
      return RadioResponse();
    }
  }
}
