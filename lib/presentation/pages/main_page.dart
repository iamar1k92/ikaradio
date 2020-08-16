import 'package:audio_service/audio_service.dart';
import 'package:base/injection_container.dart';
import 'package:base/presentation/components/player/collapse_widget.dart';
import 'package:base/presentation/components/podcast/podcast_detail.dart';
import 'package:base/presentation/components/radio/radio_detail.dart';
import 'package:base/presentation/pages/blog_page.dart';
import 'package:base/presentation/pages/category_list_page.dart';
import 'package:base/presentation/pages/favorites_page.dart';
import 'package:base/presentation/pages/home_page.dart';
import 'package:base/presentation/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MainPage extends StatelessWidget {
  final PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4 + ((sl<DotEnv>().env['BLOG_SYSTEM'] == "1") ? 1 : 0),
      child: Scaffold(
        body: SlidingUpPanel(
          controller: _panelController,
          minHeight: 80,
          maxHeight: MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
          body: StreamBuilder<MediaItem>(
            stream: AudioService.currentMediaItemStream,
            builder: (BuildContext context, AsyncSnapshot<MediaItem> snapshot) {
              return Container(
                margin: EdgeInsets.only(bottom: snapshot.hasData ? 80 : 0),
                child: TabBarView(
                  children: [
                    HomePage(),
                    FavoritesPage(),
                    CategoryListPage(),
                    if (sl<DotEnv>().env['BLOG_SYSTEM'] == "1") BlogPage(),
                    ProfilePage(),
                  ],
                ),
              );
            },
          ),
          renderPanelSheet: false,
          panelBuilder: (ScrollController scrollController) => StreamBuilder<MediaItem>(
            stream: AudioService.currentMediaItemStream,
            builder: (BuildContext context, AsyncSnapshot<MediaItem> snapshot) {
              if (!snapshot.hasData) {
                if (_panelController.isAttached) {
                  _panelController.close();
                }
                return SizedBox(height: 0);
              }

              if (snapshot.data.extras['type'] == 'ad') {
                if (_panelController.isAttached) {
                  _panelController.close();
                }
              }

              if (snapshot.data.extras['type'] == 'radio') {
                return RadioDetail(
                  scrollController: scrollController,
                  tapOnCloseButton: () {
                    if (_panelController.isAttached) {
                      _panelController.close();
                    }
                  },
                );
              } else if (snapshot.data.extras['type'] == 'podcast') {
                return PodcastDetail(
                  scrollController: scrollController,
                  tapOnCloseButton: () {
                    if (_panelController.isAttached) {
                      _panelController.close();
                    }
                  },
                );
              } else {
                return SizedBox(height: 0);
              }
            },
          ),
          collapsed: CollapseWidget(
            tapOnOpenButton: () {
              if (_panelController.isAttached) {
                _panelController.open();
              }
            },
            onEmpty: () {
              if (_panelController.isAttached) {
                _panelController.close();
              }
            },
          ),
        ),
        bottomNavigationBar: Container(
          color: Theme.of(context).primaryColor,
          child: TabBar(
            indicatorWeight: 3.0,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(FontAwesomeIcons.home, color: Colors.white)),
              Tab(icon: Icon(FontAwesomeIcons.heart, color: Colors.white)),
              Tab(icon: Icon(FontAwesomeIcons.compass, color: Colors.white)),
              if (sl<DotEnv>().env['BLOG_SYSTEM'] == "1") Tab(icon: Icon(FontAwesomeIcons.blog, color: Colors.white)),
              Tab(icon: Icon(FontAwesomeIcons.inbox, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
