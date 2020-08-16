import 'package:base/data/responses/podcast_category_response.dart';

abstract class BasePodcastCategoryRepository {
  Future<PodcastCategoryResponse> getCategories();
}
