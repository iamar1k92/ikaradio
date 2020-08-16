import 'package:base/core/services/ad_service.dart';
import 'package:base/core/services/media_player_service.dart';
import 'package:base/data/models/podcast.dart';
import 'package:base/data/models/radio_station.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:base/presentation/blocs/favorite_podcast/bloc.dart';
import 'package:base/presentation/blocs/favorite_radio/bloc.dart';
import 'package:base/presentation/components/whoops_widget.dart';
import 'package:base/presentation/components/list/item_list.dart';
import 'package:base/presentation/components/list/list_item.dart';
import 'package:base/presentation/components/list/list_item_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with AutomaticKeepAliveClientMixin<FavoritesPage> {
  final MediaPlayerService _mediaPlayerService = sl<MediaPlayerService>();
  FavoriteRadioBloc _favoriteRadioBloc;
  FavoritePodcastBloc _favoritePodcastBloc;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _favoriteRadioBloc = BlocProvider.of<FavoriteRadioBloc>(context);
    _favoriteRadioBloc.add(LoadFavoriteRadios());

    _favoritePodcastBloc = BlocProvider.of<FavoritePodcastBloc>(context);
    _favoritePodcastBloc.add(LoadFavoritePodcasts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).favorites),
          automaticallyImplyLeading: false,
          centerTitle: false,
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).radio_stations),
              Tab(text: S.of(context).podcasts),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BlocBuilder<FavoriteRadioBloc, FavoriteRadioState>(
              builder: (BuildContext context, FavoriteRadioState state) {
                if (state is ErrorFavoriteRadioState) {
                  return WhoopsWidget(
                    message: state.error,
                    onPressed: () => _favoriteRadioBloc.add(LoadFavoriteRadios()),
                  );
                } else if (state is LoadingFavoriteRadioState) {
                  return ItemList(
                    itemCount: 4,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 0);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return ListItemShimmer();
                    },
                  );
                } else {
                  if (_favoriteRadioBloc.radios.length > 0) {
                    return ItemList(
                      itemCount: _favoriteRadioBloc.radios.length,
                      separatorBuilder: (BuildContext context, int index) {
                        index++;
                        if (index % int.parse(sl<DotEnv>().env["SHOW_BANNER_EVERY_X_ITEM"] ?? "10") == 0 && (sl<DotEnv>().env["SHOW_ADMOB_BANNER"] ?? "0") == "1") {
                          return sl<AdService>().buildBannerAd();
                        } else {
                          return Divider(height: 1);
                        }
                      },
                      itemBuilder: (BuildContext context, int index) {
                        RadioStation _radioStation = _favoriteRadioBloc.radios[index];
                        return ListItem(
                          onPressed: () async => _mediaPlayerService.start(_radioStation.mediaItem),
                          imageUrl: _radioStation.cover,
                          title: _radioStation.name,
                          subTitle: _radioStation.categories.map((category) => category.name).toList().join(", "),
                          trailing: IconButton(
                            icon: Icon(_radioStation.isFavorite ? Icons.favorite : Icons.favorite_border, color: Theme.of(context).primaryIconTheme.color),
                            onPressed: () async => BlocProvider.of<FavoriteRadioBloc>(context).add(ToggleRadioFavoriteStatus(radioStation: _radioStation)),
                          ),
                        );
                      },
                    );
                  } else {
                    return WhoopsWidget(
                      message: S.of(context).no_data_found,
                      onPressed: () => _favoriteRadioBloc.add(LoadFavoriteRadios()),
                    );
                  }
                }
              },
            ),
            BlocBuilder<FavoritePodcastBloc, FavoritePodcastState>(
              builder: (BuildContext context, FavoritePodcastState state) {
                if (state is ErrorFavoritePodcastState) {
                  return WhoopsWidget(
                    message: state.error,
                    onPressed: () => _favoritePodcastBloc.add(LoadFavoritePodcasts()),
                  );
                } else if (state is LoadingFavoritePodcastState) {
                  return ItemList(
                    itemCount: 4,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 0);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return ListItemShimmer();
                    },
                  );
                } else {
                  if (_favoritePodcastBloc.podcasts.length > 0) {
                    return ItemList(
                      itemCount: _favoritePodcastBloc.podcasts.length,
                      separatorBuilder: (BuildContext context, int index) {
                        index++;
                        if (index % int.parse(sl<DotEnv>().env["SHOW_BANNER_EVERY_X_ITEM"] ?? "10") == 0 && (sl<DotEnv>().env["SHOW_ADMOB_BANNER"] ?? "0") == "1") {
                          return sl<AdService>().buildBannerAd();
                        } else {
                          return Divider(height: 1);
                        }
                      },
                      itemBuilder: (BuildContext context, int index) {
                        Podcast _podcast = _favoritePodcastBloc.podcasts[index];
                        return ListItem(
                          onPressed: () async => _mediaPlayerService.start(_podcast.mediaItem),
                          imageUrl: _podcast.cover,
                          title: _podcast.title,
                          subTitle: _podcast.categories.map((category) => category.name).toList().join(", "),
                          trailing: IconButton(
                            icon: Icon(_podcast.isFavorite ? Icons.favorite : Icons.favorite_border, color: Theme.of(context).primaryIconTheme.color),
                            onPressed: () async => BlocProvider.of<FavoritePodcastBloc>(context).add(TogglePodcastFavoriteStatus(podcast: _podcast)),
                          ),
                        );
                      },
                    );
                  } else {
                    return WhoopsWidget(
                      message: S.of(context).no_data_found,
                      onPressed: () => _favoritePodcastBloc.add(LoadFavoritePodcasts()),
                    );
                  }
                }
              },
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(height: kBottomNavigationBarHeight),
      ),
    );
  }
}
