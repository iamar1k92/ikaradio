import 'dart:async';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/data/models/radio_station.dart';
import 'package:base/data/repositories/radio_repository.dart';
import 'package:base/data/responses/radio_response.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class RadioBloc extends Bloc<RadioEvent, RadioState> {
  RadioRepository _radioRepository = sl<RadioRepository>();

  RadioBloc() : super(InitialRadioState());

  @override
  Stream<RadioState> mapEventToState(RadioEvent event) async* {
    if (event is LoadRadios) {
      yield* _mapLoadRadiosToState(event);
    } else if (event is UpdateRadio) {
      yield* _mapUpdateRadioToState(event);
    }
  }

  Stream<RadioState> _mapLoadRadiosToState(LoadRadios event) async* {
    yield LoadingRadioState();
    try {
      RadioResponse _radioResponse = await _radioRepository.getRadios(search: event.search, categoryId: event.categoryId, isFeatured: event.isFeatured, limit: event.limit);
      if (_radioResponse.error == null) {
        yield LoadedRadioState(radios: _radioResponse.radios);
      } else {
        yield ErrorRadioState(error: _radioResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorRadioState(error: e.message.toString());
    } catch (e) {

      yield ErrorRadioState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }

  Stream<RadioState> _mapUpdateRadioToState(UpdateRadio event) async* {
    List<RadioStation> radios = (state as LoadedRadioState).radios.map((radio) => radio.id == event.radioStation.id ? event.radioStation : radio).toList();
    yield LoadedRadioState(radios: radios);
  }
}
