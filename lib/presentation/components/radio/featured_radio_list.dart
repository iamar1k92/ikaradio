import 'package:base/core/services/media_player_service.dart';
import 'package:base/data/models/radio_station.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:base/presentation/blocs/language/bloc.dart';
import 'package:base/presentation/blocs/radio/bloc.dart';
import 'package:base/presentation/components/featured/featured_item.dart';
import 'package:base/presentation/components/featured/featured_list.dart';
import 'package:base/presentation/components/whoops_widget.dart';
import 'package:base/presentation/components/featured/featured_item_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeaturedRadioList extends StatefulWidget {
  @override
  _FeaturedRadioListState createState() => _FeaturedRadioListState();
}

class _FeaturedRadioListState extends State<FeaturedRadioList> {
  final RadioBloc featuredRadioBloc = RadioBloc();
  final MediaPlayerService _mediaPlayerService = sl<MediaPlayerService>();

  @override
  void initState() {
    super.initState();
    featuredRadioBloc.add(LoadRadios(isFeatured: true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguageBloc, LanguageState>(
      listener: (BuildContext context, LanguageState state) {
        featuredRadioBloc.add(LoadRadios(isFeatured: true));
      },
      child: BlocProvider(
        create: (BuildContext context) => featuredRadioBloc,
        child: BlocBuilder(
          bloc: featuredRadioBloc,
          builder: (BuildContext context, RadioState state) {
            if (state is LoadedRadioState) {
              if (state.radios.length > 0) {
                return FeaturedList(
                  title: S.of(context).featured_radios,
                  itemCount: state.radios.length,
                  itemBuilder: (BuildContext context, int index) {
                    RadioStation _radioStation = state.radios[index];
                    return FeaturedItem(
                      onPressed: () async => _mediaPlayerService.start(_radioStation.mediaItem, queue: state.radios.map((e) => e.mediaItem).toList()),
                      imageUrl: _radioStation.cover,
                      title: _radioStation.name,
                      subTitle: _radioStation.categories.map((category) => category.name).toList().join(", "),
                    );
                  },
                );
              } else {
                return SizedBox(height: 0);
              }
            } else if (state is ErrorRadioState) {
              return WhoopsWidget(
                message: state.error,
                onPressed: () => featuredRadioBloc.add(LoadRadios(isFeatured: true)),
              );
            } else if (state is LoadingRadioState) {
              return FeaturedList(
                title: S.of(context).featured_radios,
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return FeaturedItemShimmer();
                },
              );
            } else {
              return WhoopsWidget(
                message: S.of(context).no_data_found,
                onPressed: () => featuredRadioBloc.add(LoadRadios(isFeatured: true)),
              );
            }
          },
        ),
      ),
    );
  }
}
