import 'package:base/core/services/ad_service.dart';
import 'package:base/core/services/media_player_service.dart';
import 'package:base/data/models/podcast.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:base/presentation/blocs/favorite_podcast/bloc.dart';
import 'package:base/presentation/blocs/language/bloc.dart';
import 'package:base/presentation/blocs/podcast/bloc.dart';
import 'package:base/presentation/components/whoops_widget.dart';
import 'package:base/presentation/components/list/item_list.dart';
import 'package:base/presentation/components/list/list_item.dart';
import 'package:base/presentation/components/list/list_item_shimmer.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PodcastList extends StatefulWidget {
  final PodcastEvent podcastEvent;
  final bool showTitle;

  const PodcastList({Key key, @required this.podcastEvent, this.showTitle = true}) : super(key: key);

  @override
  _PodcastListState createState() => _PodcastListState();
}

class _PodcastListState extends State<PodcastList> {
  final PodcastBloc _podcastBloc = PodcastBloc();

  final MediaPlayerService _mediaPlayerService = sl<MediaPlayerService>();

  @override
  void initState() {
    super.initState();
    _podcastBloc.add(widget.podcastEvent);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguageBloc, LanguageState>(
      listener: (BuildContext context, LanguageState state) {
        _podcastBloc.add(widget.podcastEvent);
      },
      child: BlocProvider(
        create: (BuildContext context) => _podcastBloc,
        child: BlocListener<FavoritePodcastBloc, FavoritePodcastState>(
          listener: (BuildContext context, FavoritePodcastState state) {
            if (state is PodcastFavoriteStatusChanged) {
              BlocProvider.of<PodcastBloc>(context).add(UpdatePodcast(podcast: state.podcast));
            } else if (state is ErrorFavoritePodcastState) {
              FlushbarHelper.createError(title: S.of(context).error, message: state.error, duration: Duration(seconds: 5))..show(context);
            }
          },
          child: BlocBuilder(
            bloc: _podcastBloc,
            builder: (BuildContext context, PodcastState state) {
              if (state is LoadedPodcastState) {
                if (state.podcasts.length > 0) {
                  return ItemList(
                    title: widget.showTitle ? S.of(context).podcasts : null,
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
                        onPressed: () async => _mediaPlayerService.start(_podcast.queue.first, queue: _podcast.queue),
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
                  );
                } else {
                  return SizedBox(height: 0);
                }
              } else if (state is ErrorPodcastState) {
                return WhoopsWidget(
                  message: state.error,
                  onPressed: () => _podcastBloc.add(widget.podcastEvent),
                );
              } else if (state is LoadingPodcastState) {
                return ItemList(
                  title: widget.showTitle ? S.of(context).podcasts : null,
                  itemCount: 4,
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
                  onPressed: () => _podcastBloc.add(widget.podcastEvent),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
