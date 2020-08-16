import 'dart:async';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/data/repositories/slider_repository.dart';
import 'package:base/data/responses/slider_response.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class SliderBloc extends Bloc<SliderEvent, SliderState> {
  SliderRepository _sliderRepository = sl<SliderRepository>();

  SliderBloc() : super(InitialSliderState());

  @override
  Stream<SliderState> mapEventToState(SliderEvent event) async* {
    if (event is LoadSliders) {
      yield* _mapLoadSlidersToState(event);
    } 
  }

  Stream<SliderState> _mapLoadSlidersToState(LoadSliders event) async* {
    yield LoadingSliderState();
    try {
      SliderResponse _sliderResponse = await _sliderRepository.getSliders();
      if (_sliderResponse.error == null) {
        yield SlidersLoaded(sliders: _sliderResponse.sliders);
      } else {
        yield ErrorSliderState(error: _sliderResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorSliderState(error: e.message.toString());
    } catch (e) {
      yield ErrorSliderState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }

}
