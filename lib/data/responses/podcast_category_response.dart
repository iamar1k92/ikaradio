import 'package:base/data/models/podcast_category.dart';

class PodcastCategoryResponse {
  final List<PodcastCategory> categories;
  final String error;

  PodcastCategoryResponse({this.categories, this.error});

  PodcastCategoryResponse.success(json)
      : categories = List<PodcastCategory>.from((json as List).map((x) => PodcastCategory.fromJson(x))),
        error = null;

  PodcastCategoryResponse.error(String error)
      : categories = null,
        error = error;

  @override
  String toString() {
    return 'CategoryResponse{categories: $categories, error: $error}';
  }
}
