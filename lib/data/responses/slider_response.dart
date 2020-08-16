import 'package:base/data/models/slider.dart';

class SliderResponse {
  final List<Slider> sliders;
  final String error;

  SliderResponse({this.sliders, this.error});

  SliderResponse.success(json)
      : sliders = List<Slider>.from((json as List).map((x) => Slider.fromJson(x))),
        error = null;

  SliderResponse.error(String error)
      : sliders = null,
        error = error;

  @override
  String toString() {
    return 'SliderResponse{sliders: $sliders, error: $error}';
  }
}
