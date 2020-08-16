import 'package:base/data/responses/search_response.dart';
import 'package:meta/meta.dart';

abstract class BaseSearchRepository {
  Future<SearchResponse> search({@required String query});
}
