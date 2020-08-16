import 'package:base/core/services/media_player_service.dart';
import 'package:base/data/models/podcast.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:base/presentation/blocs/language/bloc.dart';
import 'package:base/presentation/blocs/podcast/bloc.dart';
import 'package:base/presentation/components/featured/featured_item.dart';
import 'package:base/presentation/components/featured/featured_list.dart';
import 'package:base/presentation/components/whoops_widget.dart';
import 'package:base/presentation/components/featured/featured_item_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeaturedPodcastList extends StatefulWidget {
  @override
  _FeaturedPodcastListState createState() => _FeaturedPodcastListState();
}

class _FeaturedPodcastListState extends State<FeaturedPodcastList> {
  final PodcastBloc featuredPodcastBloc = PodcastBloc();

  final MediaPlayerService _mediaPlayerService = sl<MediaPlayerService>();

  @override
  void initState() {
    super.initState();
    featuredPodcastBloc.add(LoadPodcasts(isFeatured: true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguageBloc, LanguageState>(
      listener: (BuildContext context, LanguageState state) {
        featuredPodcastBloc.add(LoadPodcasts(isFeatured: true));
      },
      child: BlocProvider(
        create: (BuildContext context) => featuredPodcastBloc,
        child: BlocBuilder(
          bloc: featuredPodcastBloc,
          builder: (BuildContext context, PodcastState state) {
            if (state is LoadedPodcastState) {
              if (state.podcasts.length > 0) {
                return FeaturedList(
                  title: S.of(context).featured_podcasts,
                  itemCount: state.podcasts.length,
                  itemBuilder: (BuildContext context, int index) {
                    Podcast _podcastStation = state.podcasts[index];
                    return FeaturedItem(
                      onPressed: () async => _mediaPlayerService.start(_podcastStation.mediaItem, queue: state.podcasts.map((e) => e.mediaItem).toList()),
                      imageUrl: _podcastStation.cover,
                      title: _podcastStation.title,
                      subTitle: _podcastStation.categories.map((category) => category.name).toList().join(", "),
                    );
                  },
                );
              } else {
                return SizedBox(height: 0);
              }
            } else if (state is ErrorPodcastState) {
              return WhoopsWidget(
                message: state.error,
                onPressed: () => featuredPodcastBloc.add(LoadPodcasts(isFeatured: true)),
              );
            } else if (state is LoadingPodcastState) {
              return FeaturedList(
                title: S.of(context).featured_podcasts,
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return FeaturedItemShimmer();
                },
              );
            } else {
              return WhoopsWidget(
                message: S.of(context).no_data_found,
                onPressed: () => featuredPodcastBloc.add(LoadPodcasts(isFeatured: true)),
              );
            }
          },
        ),
      ),
    );
  }
}
