import 'package:base/generated/l10n.dart';
import 'package:base/presentation/blocs/podcast/podcast_event.dart';
import 'package:base/presentation/blocs/radio/radio_event.dart';
import 'package:base/presentation/components/podcast/featured_podcast_list.dart';
import 'package:base/presentation/components/podcast/podcast_list.dart';
import 'package:base/presentation/components/radio/featured_radio_list.dart';
import 'package:base/presentation/components/radio/radio_list.dart';
import 'package:base/presentation/components/slider_widget.dart';
import 'package:base/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage>, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).explore),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () => Navigator.of(context).pushNamed(Routes.search)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SliderWidget(),
            FeaturedPodcastList(),
            FeaturedRadioList(),
            RadioList(radioEvent: LoadRadios(limit: 10)),
            PodcastList(podcastEvent: LoadPodcasts(limit: 10)),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(height: kBottomNavigationBarHeight),
    );
  }
}
