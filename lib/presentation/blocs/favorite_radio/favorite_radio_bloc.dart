import 'dart:async';
import 'package:base/core/services/media_player_service.dart';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/data/models/radio_station.dart';
import 'package:base/data/repositories/radio_repository.dart';
import 'package:base/data/responses/radio_response.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class FavoriteRadioBloc extends Bloc<FavoriteRadioEvent, FavoriteRadioState> {
  RadioRepository _radioRepository = sl<RadioRepository>();
  List<RadioStation> radios = List<RadioStation>();

  FavoriteRadioBloc() : super(InitialFavoriteRadioState());

  @override
  Stream<FavoriteRadioState> mapEventToState(FavoriteRadioEvent event) async* {
    if (event is ToggleRadioFavoriteStatus) {
      yield LoadingFavoriteRadioState(event.radioStation.id);
      yield* _mapToggleRadioFavoriteStatusToState(event);
    } else if (event is LoadFavoriteRadios) {
      yield LoadingFavoriteRadioState(0);
      yield* _mapGetFavoritesToState(event);
    }
  }

  Stream<FavoriteRadioState> _mapGetFavoritesToState(LoadFavoriteRadios event) async* {
    try {
      RadioResponse _radioResponse = await _radioRepository.getFavoriteRadios();
      if (_radioResponse.error == null) {
        radios = _radioResponse.radios;
        yield LoadedFavoriteRadiosState(radios: _radioResponse.radios);
      } else {
        yield ErrorFavoriteRadioState(error: _radioResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorFavoriteRadioState(error: e.message.toString());
    } catch (e) {
      yield ErrorFavoriteRadioState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }

  Stream<FavoriteRadioState> _mapToggleRadioFavoriteStatusToState(ToggleRadioFavoriteStatus event) async* {
    try {
      //change radio status
      event.radioStation.isFavorite = !event.radioStation.isFavorite;

      RadioResponse _radioResponse;
      if (event.radioStation.isFavorite) {
        _radioResponse = await _radioRepository.addFavoriteRadio(event.radioStation);
      } else {
        _radioResponse = await _radioRepository.removeFavoriteRadio(event.radioStation);
      }
      if (_radioResponse.error == null) {
        //update media player status
        MediaPlayerService().updateItem(event.radioStation.mediaItem);

        if (event.radioStation.isFavorite) {
          radios.add(event.radioStation);
        } else {
          radios.removeWhere((radio) => radio.id == event.radioStation.id);
        }

        yield RadioFavoriteStatusChanged(radioStation: event.radioStation);
      } else {
        yield ErrorFavoriteRadioState(error: _radioResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorFavoriteRadioState(error: e.message.toString());
    } catch (e) {
      yield ErrorFavoriteRadioState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }
}
