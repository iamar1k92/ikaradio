import 'package:base/data/responses/slider_response.dart';

abstract class BaseSliderRepository {
  Future<SliderResponse> getSliders();

}
