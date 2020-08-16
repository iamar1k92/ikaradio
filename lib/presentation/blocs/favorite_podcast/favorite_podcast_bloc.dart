import 'dart:async';
import 'package:base/core/services/media_player_service.dart';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/data/models/podcast.dart';
import 'package:base/data/repositories/podcast_repository.dart';
import 'package:base/data/responses/podcast_response.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class FavoritePodcastBloc extends Bloc<FavoritePodcastEvent, FavoritePodcastState> {
  PodcastRepository _podcastRepository = sl<PodcastRepository>();
  List<Podcast> podcasts = List<Podcast>();

  FavoritePodcastBloc() : super(InitialFavoritePodcastState());

  @override
  Stream<FavoritePodcastState> mapEventToState(FavoritePodcastEvent event) async* {
    if (event is TogglePodcastFavoriteStatus) {
      yield LoadingFavoritePodcastState(event.podcast.id);
      yield* _mapTogglePodcastFavoriteStatusToState(event);
    } else if (event is LoadFavoritePodcasts) {
      yield LoadingFavoritePodcastState(0);
      yield* _mapGetFavoritesToState(event);
    }
  }

  Stream<FavoritePodcastState> _mapGetFavoritesToState(LoadFavoritePodcasts event) async* {
    try {
      PodcastResponse _podcastResponse = await _podcastRepository.getFavoritePodcasts();
      if (_podcastResponse.error == null) {
        podcasts = _podcastResponse.podcasts;
        yield LoadedFavoritePodcastsState(podcasts: _podcastResponse.podcasts);
      } else {
        yield ErrorFavoritePodcastState(error: _podcastResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorFavoritePodcastState(error: e.message.toString());
    } catch (e) {
      yield ErrorFavoritePodcastState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }

  Stream<FavoritePodcastState> _mapTogglePodcastFavoriteStatusToState(TogglePodcastFavoriteStatus event) async* {
    try {
      //change podcast status
      event.podcast.isFavorite = !event.podcast.isFavorite;

      PodcastResponse _podcastResponse;
      if (event.podcast.isFavorite) {
        _podcastResponse = await _podcastRepository.addFavoritePodcast(event.podcast);
      } else {
        _podcastResponse = await _podcastRepository.removeFavoritePodcast(event.podcast);
      }
      if (_podcastResponse.error == null) {
        //update media player status
        MediaPlayerService().updateItem(event.podcast.mediaItem);

        if (event.podcast.isFavorite) {
          podcasts.add(event.podcast);
        } else {
          podcasts.removeWhere((podcast) => podcast.id == event.podcast.id);
        }

        yield PodcastFavoriteStatusChanged(podcast: event.podcast);
      } else {
        yield ErrorFavoritePodcastState(error: _podcastResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorFavoritePodcastState(error: e.message.toString());
    } catch (e) {
      yield ErrorFavoritePodcastState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }
}
