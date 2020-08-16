import 'package:base/data/models/slider.dart';
import 'package:meta/meta.dart';

abstract class SliderState {}

class InitialSliderState extends SliderState {}

class LoadingSliderState extends SliderState {}

class SlidersLoaded extends SliderState {
  final List<Slider> sliders;

  SlidersLoaded({@required this.sliders});
}

class ErrorSliderState extends SliderState {
  final String error;

  ErrorSliderState({@required this.error});
}
