import 'package:base/core/services/ad_service.dart';
import 'package:base/core/services/media_player_service.dart';
import 'package:base/data/models/podcast.dart';
import 'package:base/data/models/radio_station.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:base/presentation/blocs/favorite_podcast/bloc.dart';
import 'package:base/presentation/blocs/favorite_radio/bloc.dart';
import 'package:base/presentation/blocs/search/bloc.dart';
import 'package:base/presentation/blocs/search/search_bloc.dart';
import 'package:base/presentation/blocs/search/search_event.dart';
import 'package:base/presentation/components/whoops_widget.dart';
import 'package:base/presentation/components/list/item_list.dart';
import 'package:base/presentation/components/list/list_item.dart';
import 'package:base/presentation/components/list/list_item_shimmer.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchQueryController = TextEditingController();

  final SearchBloc _searchBloc = SearchBloc();

  final MediaPlayerService _mediaPlayerService = sl<MediaPlayerService>();

  String _query;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchQueryController,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: (val) {
              setState(() {
                if (val.length > 0) {
                  _query = val;
                  _searchBloc.add(Search(query: val));
                }
              });
            },
            decoration: InputDecoration(
              hintText: S.of(context).search,
              border: InputBorder.none,
            ),
            style: TextStyle(fontSize: 16.0),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).radio_stations),
              Tab(text: S.of(context).podcasts),
            ],
          ),
        ),
        body: BlocProvider<SearchBloc>(
          create: (BuildContext context) => _searchBloc,
          child: MultiBlocListener(
            listeners: [
              BlocListener<FavoriteRadioBloc, FavoriteRadioState>(listener: (BuildContext context, FavoriteRadioState state) {
                if (state is RadioFavoriteStatusChanged) {
                  BlocProvider.of<SearchBloc>(context).add(UpdateRadio(radioStation: state.radioStation));
                } else if (state is ErrorFavoriteRadioState) {
                  FlushbarHelper.createError(title: S.of(context).error, message: state.error, duration: Duration(seconds: 5))..show(context);
                }
              }),
              BlocListener<FavoritePodcastBloc, FavoritePodcastState>(listener: (BuildContext context, FavoritePodcastState state) {
                if (state is PodcastFavoriteStatusChanged) {
                  BlocProvider.of<SearchBloc>(context).add(UpdatePodcast(podcast: state.podcast));
                } else if (state is ErrorFavoritePodcastState) {
                  FlushbarHelper.createError(title: S.of(context).error, message: state.error, duration: Duration(seconds: 5))..show(context);
                }
              })
            ],
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (BuildContext context, SearchState state) {
                if (state is SearchResultState) {
                  if (state.radios.length > 0 || state.podcasts.length > 0) {
                    return TabBarView(
                      children: [
                        if (state.radios.length > 0)
                          SingleChildScrollView(
                            child: ItemList(
                              itemCount: state.radios.length,
                              separatorBuilder: (BuildContext context, int index) {
                                index++;
                                if (index % int.parse(sl<DotEnv>().env["SHOW_BANNER_EVERY_X_ITEM"] ?? "10") == 0 && (sl<DotEnv>().env["SHOW_ADMOB_BANNER"] ?? "0") == "1") {
                                  return sl<AdService>().buildBannerAd();
                                } else {
                                  return Divider(height: 1);
                                }
                              },
                              itemBuilder: (BuildContext context, int index) {
                                RadioStation _radioStation = state.radios[index];
                                return ListItem(
                                  onPressed: () async => _mediaPlayerService.start(_radioStation.mediaItem, queue: state.radios.map((e) => e.mediaItem).toList()),
                                  imageUrl: _radioStation.cover,
                                  title: _radioStation.name,
                                  subTitle: _radioStation.categories.map((category) => category.name).toList().join(", "),
                                  trailing: BlocBuilder<FavoriteRadioBloc, FavoriteRadioState>(
                                    builder: (BuildContext context, FavoriteRadioState state) {
                                      if (state is LoadingFavoriteRadioState && state.radioId == _radioStation.id) {
                                        return Padding(padding: EdgeInsets.all(12.0), child: SizedBox(width: 20.0, height: 20.0, child: CircularProgressIndicator()));
                                      } else {
                                        return IconButton(
                                          icon: Icon(_radioStation.isFavorite ? Icons.favorite : Icons.favorite_border, color: Theme.of(context).primaryIconTheme.color),
                                          onPressed: () => BlocProvider.of<FavoriteRadioBloc>(context).add(ToggleRadioFavoriteStatus(radioStation: _radioStation)),
                                        );
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          WhoopsWidget(
                            message: S.of(context).no_data_found,
                            onPressed: () => _searchBloc.add(Search(query: _query)),
                          ),
                        if (state.podcasts.length > 0)
                          SingleChildScrollView(
                            child: ItemList(
                              physics: ScrollPhysics(),
                              itemCount: state.podcasts.length,
                              separatorBuilder: (BuildContext context, int index) {
                                index++;
                                if (index % int.parse(sl<DotEnv>().env["SHOW_BANNER_EVERY_X_ITEM"] ?? "10") == 0 && (sl<DotEnv>().env["SHOW_ADMOB_BANNER"] ?? "0") == "1") {
                                  return sl<AdService>().buildBannerAd();
                                } else {
                                  return Divider(height: 1);
                                }
                              },
                              itemBuilder: (BuildContext context, int index) {
                                Podcast _podcast = state.podcasts[index];
                                return ListItem(
                                  onPressed: () async => _mediaPlayerService.start(_podcast.mediaItem, queue: state.podcasts.map((e) => e.mediaItem).toList()),
                                  imageUrl: _podcast.cover,
                                  title: _podcast.title,
                                  subTitle: _podcast.categories.map((category) => category.name).toList().join(", "),
                                  trailing: BlocBuilder<FavoritePodcastBloc, FavoritePodcastState>(
                                    builder: (BuildContext context, FavoritePodcastState state) {
                                      if (state is LoadingFavoritePodcastState && state.podcastId == _podcast.id) {
                                        return Padding(padding: EdgeInsets.all(12.0), child: SizedBox(width: 20.0, height: 20.0, child: CircularProgressIndicator()));
                                      } else {
                                        return IconButton(
                                          icon: Icon(_podcast.isFavorite ? Icons.favorite : Icons.favorite_border, color: Theme.of(context).primaryIconTheme.color),
                                          onPressed: () async => BlocProvider.of<FavoritePodcastBloc>(context).add(TogglePodcastFavoriteStatus(podcast: _podcast)),
                                        );
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          WhoopsWidget(
                            message: S.of(context).no_data_found,
                            onPressed: () => _searchBloc.add(Search(query: _query)),
                          )
                      ],
                    );
                  } else {
                    return WhoopsWidget(
                      message: S.of(context).no_data_found,
                      onPressed: () => _searchBloc.add(Search(query: _query)),
                    );
                  }
                } else if (state is ErrorSearchState) {
                  return WhoopsWidget(
                    message: state.error,
                    onPressed: () => _searchBloc.add(Search(query: _query)),
                  );
                } else if (state is LoadingSearchState) {
                  return ItemList(
                    itemCount: 4,
                    physics: ScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 0);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return ListItemShimmer();
                    },
                  );
                } else {
                  return WhoopsWidget(
                    message: S.of(context).no_data_found,
                    onPressed: () => _searchBloc.add(Search(query: _query)),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
