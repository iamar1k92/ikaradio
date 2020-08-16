import 'package:base/core/services/ad_service.dart';
import 'package:base/core/services/media_player_service.dart';
import 'package:base/data/models/radio_station.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:base/presentation/blocs/favorite_radio/bloc.dart';
import 'package:base/presentation/blocs/language/bloc.dart';
import 'package:base/presentation/blocs/radio/bloc.dart';
import 'package:base/presentation/components/whoops_widget.dart';
import 'package:base/presentation/components/list/item_list.dart';
import 'package:base/presentation/components/list/list_item.dart';
import 'package:base/presentation/components/list/list_item_shimmer.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RadioList extends StatefulWidget {
  final RadioEvent radioEvent;
  final bool showTitle;

  const RadioList({Key key, @required this.radioEvent, this.showTitle = true}) : super(key: key);

  @override
  _RadioListState createState() => _RadioListState();
}

class _RadioListState extends State<RadioList> {
  final RadioBloc _radioBloc = RadioBloc();

  final MediaPlayerService _mediaPlayerService = sl<MediaPlayerService>();

  @override
  void initState() {
    super.initState();
    _radioBloc.add(widget.radioEvent);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguageBloc, LanguageState>(
      listener: (BuildContext context, LanguageState state) {
        _radioBloc.add(widget.radioEvent);
      },
      child: BlocProvider(
        create: (BuildContext context) => _radioBloc,
        child: BlocListener<FavoriteRadioBloc, FavoriteRadioState>(
          listener: (BuildContext context, FavoriteRadioState state) {
            if (state is RadioFavoriteStatusChanged) {
              BlocProvider.of<RadioBloc>(context).add(UpdateRadio(radioStation: state.radioStation));
            } else if (state is ErrorFavoriteRadioState) {
              FlushbarHelper.createError(title: S.of(context).error, message: state.error, duration: Duration(seconds: 5))..show(context);
            }
          },
          child: BlocBuilder(
            bloc: _radioBloc,
            builder: (BuildContext context, RadioState state) {
              if (state is LoadedRadioState) {
                if (state.radios.length > 0) {
                  return ItemList(
                    title: widget.showTitle ? S.of(context).radio_stations : null,
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
                                onPressed: () async => BlocProvider.of<FavoriteRadioBloc>(context).add(ToggleRadioFavoriteStatus(radioStation: _radioStation)),
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
              } else if (state is ErrorRadioState) {
                return WhoopsWidget(
                  message: state.error,
                  onPressed: () => _radioBloc.add(widget.radioEvent),
                );
              } else if (state is LoadingRadioState) {
                return ItemList(
                  title: widget.showTitle ? S.of(context).radio_stations : null,
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
                  onPressed: () => _radioBloc.add(widget.radioEvent),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
