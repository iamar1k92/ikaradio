import 'package:base/data/providers/slider_api_provider.dart';
import 'package:base/data/responses/slider_response.dart';
import 'package:base/domain/interfaces/base_slider_repository.dart';
import 'package:base/injection_container.dart';

class SliderRepository implements BaseSliderRepository {
  final SliderApiProvider _sliderApiProvider = sl<SliderApiProvider>();

  @override
  Future<SliderResponse> getSliders() async {
    return await _sliderApiProvider.getSliders();
  }
}
