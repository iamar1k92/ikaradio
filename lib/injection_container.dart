import 'package:base/core/network/network_helper.dart';
import 'package:base/core/services/ad_service.dart';
import 'package:base/core/services/media_player_service.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/core/services/navigation_service.dart';
import 'package:base/data/providers/audio_ad_api_provider.dart';
import 'package:base/data/providers/blog_api_provider.dart';
import 'package:base/data/providers/blog_category_api_provider.dart';
import 'package:base/data/providers/category_api_provider.dart';
import 'package:base/data/providers/notification_api_provider.dart';
import 'package:base/data/providers/podcast_api_provider.dart';
import 'package:base/data/providers/podcast_category_api_provider.dart';
import 'package:base/data/providers/radio_api_provider.dart';
import 'package:base/data/providers/search_api_provider.dart';
import 'package:base/data/providers/slider_api_provider.dart';
import 'package:base/data/providers/user_api_provider.dart';
import 'package:base/data/repositories/audio_ad_repository.dart';
import 'package:base/data/repositories/blog_category_repository.dart';
import 'package:base/data/repositories/blog_repository.dart';
import 'package:base/data/repositories/category_repository.dart';
import 'package:base/data/repositories/notification_repository.dart';
import 'package:base/data/repositories/podcast_category_repository.dart';
import 'package:base/data/repositories/podcast_repository.dart';
import 'package:base/data/repositories/radio_repository.dart';
import 'package:base/data/repositories/search_repository.dart';
import 'package:base/data/repositories/slider_repository.dart';
import 'package:base/data/repositories/user_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => AdService());
  sl.registerLazySingleton(() => MediaPlayerService());
  sl.registerLazySingleton(() => NavigationService());
  sl.registerLazySingleton(() => DotEnv());
  sl.registerLazySingleton(() => NetworkHelper());
  sl.registerLazySingleton(() => SharedPreferenceHelper(sl()));
  sl.registerLazySingleton(() => SharedPreferences.getInstance());
  sl.registerLazySingleton(() => AudioPlayer());

  sl.registerLazySingleton(() => UserRepository());
  sl.registerLazySingleton(() => CategoryRepository());
  sl.registerLazySingleton(() => PodcastCategoryRepository());
  sl.registerLazySingleton(() => NotificationRepository());
  sl.registerLazySingleton(() => RadioRepository());
  sl.registerLazySingleton(() => PodcastRepository());
  sl.registerLazySingleton(() => SliderRepository());
  sl.registerLazySingleton(() => SearchRepository());
  sl.registerLazySingleton(() => BlogRepository());
  sl.registerLazySingleton(() => BlogCategoryRepository());
  sl.registerLazySingleton(() => AudioAdRepository());

  sl.registerLazySingleton(() => UserApiProvider());
  sl.registerLazySingleton(() => CategoryApiProvider());
  sl.registerLazySingleton(() => PodcastCategoryApiProvider());
  sl.registerLazySingleton(() => NotificationApiProvider());
  sl.registerLazySingleton(() => RadioApiProvider());
  sl.registerLazySingleton(() => PodcastApiProvider());
  sl.registerLazySingleton(() => SliderApiProvider());
  sl.registerLazySingleton(() => SearchApiProvider());
  sl.registerLazySingleton(() => BlogApiProvider());
  sl.registerLazySingleton(() => BlogCategoryApiProvider());
  sl.registerLazySingleton(() => AudioAdApiProvider());
}
