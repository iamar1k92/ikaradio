import 'package:base/generated/l10n.dart';
import 'package:base/presentation/components/category_list_widget.dart';
import 'package:base/presentation/components/podcast_category_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> with AutomaticKeepAliveClientMixin<CategoryListPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).categories),
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
            CategoryListWidget(),
            PodcastCategoryListWidget(),
          ],
        ),
        bottomNavigationBar: SizedBox(height: kBottomNavigationBarHeight),
      ),
    );
  }
}
