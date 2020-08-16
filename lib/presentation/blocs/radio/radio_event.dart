import 'package:base/data/models/radio_station.dart';
import 'package:meta/meta.dart';

abstract class RadioEvent {
  const RadioEvent();
}

class LoadRadios extends RadioEvent {
  final int categoryId;
  final String search;
  final bool isFeatured;
  final int limit;

  LoadRadios({this.categoryId, this.search, this.isFeatured, this.limit});

  @override
  String toString() {
    return 'LoadRadios{categoryId: $categoryId, search: $search, isFeatured: $isFeatured, limit: $limit}';
  }
}

class UpdateRadio extends RadioEvent {
  final RadioStation radioStation;

  UpdateRadio({@required this.radioStation});
}
