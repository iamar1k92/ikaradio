import 'dart:async';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/data/models/podcast.dart';
import 'package:base/data/repositories/podcast_repository.dart';
import 'package:base/data/responses/podcast_response.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class PodcastBloc extends Bloc<PodcastEvent, PodcastState> {
  PodcastRepository _podcastRepository = sl<PodcastRepository>();

  PodcastBloc() : super(InitialPodcastState());

  @override
  Stream<PodcastState> mapEventToState(PodcastEvent event) async* {
    if (event is LoadPodcasts) {
      yield* _mapLoadPodcastsToState(event);
    } else if (event is UpdatePodcast) {
      yield* _mapUpdatePodcastToState(event);
    }
  }

  Stream<PodcastState> _mapLoadPodcastsToState(LoadPodcasts event) async* {
    yield LoadingPodcastState();
    try {
      PodcastResponse _podcastResponse = await _podcastRepository.getPodcasts(search: event.search, categoryId: event.categoryId, isFeatured: event.isFeatured, limit: event.limit);
      if (_podcastResponse.error == null) {
        yield LoadedPodcastState(podcasts: _podcastResponse.podcasts);
      } else {
        yield ErrorPodcastState(error: _podcastResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorPodcastState(error: e.message.toString());
    } catch (e) {
      yield ErrorPodcastState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }

  Stream<PodcastState> _mapUpdatePodcastToState(UpdatePodcast event) async* {
    List<Podcast> podcasts = (state as LoadedPodcastState).podcasts.map((podcast) => podcast.id == event.podcast.id ? event.podcast : podcast).toList();
    yield LoadedPodcastState(podcasts: podcasts);
  }
}
