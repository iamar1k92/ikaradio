import 'dart:async';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/data/models/podcast.dart';
import 'package:base/data/models/radio_station.dart';
import 'package:base/data/repositories/search_repository.dart';
import 'package:base/data/responses/search_response.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchRepository _searchRepository = sl<SearchRepository>();

  SearchBloc() : super(InitialSearchState());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is Search) {
      yield* _mapSearchToState(event);
    }else if(event is UpdateRadio){
      yield* _mapUpdateRadioToState(event);
    }else if(event is UpdatePodcast){
      yield* _mapUpdatePodcastToState(event);
    }
  }

  Stream<SearchState> _mapSearchToState(Search event) async* {
    yield LoadingSearchState();
    try {
      SearchResponse _searchResponse = await _searchRepository.search(query: event.query);
      if (_searchResponse.error == null) {
        yield SearchResultState(radios: _searchResponse.radios, podcasts: _searchResponse.podcasts);
      } else {
        yield ErrorSearchState(error: _searchResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorSearchState(error: e.message.toString());
    } catch (e) {
      yield ErrorSearchState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }

  Stream<SearchState> _mapUpdateRadioToState(UpdateRadio event) async* {
    List<RadioStation> radios = (state as SearchResultState).radios.map((radio) => radio.id == event.radioStation.id ? event.radioStation : radio).toList();
    yield SearchResultState(radios: radios, podcasts: (state as SearchResultState).podcasts);
  }

  Stream<SearchState> _mapUpdatePodcastToState(UpdatePodcast event) async* {
    List<Podcast> podcasts = (state as SearchResultState).podcasts.map((podcast) => podcast.id == event.podcast.id ? event.podcast : podcast).toList();
    yield SearchResultState(podcasts: podcasts, radios: (state as SearchResultState).radios);
  }
}
