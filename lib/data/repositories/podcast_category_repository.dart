import 'package:base/data/providers/podcast_category_api_provider.dart';
import 'package:base/data/responses/podcast_category_response.dart';
import 'package:base/domain/interfaces/base_podcast_category_repository.dart';
import 'package:base/injection_container.dart';

class PodcastCategoryRepository implements BasePodcastCategoryRepository {
  final PodcastCategoryApiProvider _podcastCategoryApiProvider = sl<PodcastCategoryApiProvider>();

  @override
  Future<PodcastCategoryResponse> getCategories() async {
    return await _podcastCategoryApiProvider.getCategories();
  }
}
