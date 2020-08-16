import 'package:base/data/models/podcast_category.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/presentation/blocs/language/bloc.dart';
import 'package:base/presentation/blocs/podcast/podcast_event.dart';
import 'package:base/presentation/blocs/podcast_category/bloc.dart';
import 'package:base/presentation/components/category/category_list.dart';
import 'package:base/presentation/components/category/category_list_item.dart';
import 'package:base/presentation/components/category/category_list_item_shimmer.dart';
import 'package:base/presentation/components/whoops_widget.dart';
import 'package:base/presentation/components/podcast/podcast_list.dart';
import 'package:base/presentation/pages/list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PodcastCategoryListWidget extends StatefulWidget {
  @override
  _PodcastCategoryListWidgetState createState() => _PodcastCategoryListWidgetState();
}

class _PodcastCategoryListWidgetState extends State<PodcastCategoryListWidget> with AutomaticKeepAliveClientMixin<PodcastCategoryListWidget> {
  final PodcastCategoryBloc _podcastCategoryBloc = PodcastCategoryBloc();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _podcastCategoryBloc.add(LoadPodcastCategories());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<LanguageBloc, LanguageState>(
      listener: (BuildContext context, LanguageState state) {
        _podcastCategoryBloc.add(LoadPodcastCategories());
      },
      child: BlocProvider<PodcastCategoryBloc>(
        create: (BuildContext context) => _podcastCategoryBloc,
        child: BlocBuilder<PodcastCategoryBloc, PodcastCategoryState>(
          bloc: _podcastCategoryBloc,
          builder: (BuildContext context, PodcastCategoryState state) {
            if (state is LoadingPodcastCategoryState) {
              return CategoryListItemShimmer();
            } else if (state is LoadedPodcastCategoryState) {
              if (state.categories.length > 0) {
                return CategoryList(
                  itemCount: state.categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    PodcastCategory _category = state.categories[index];
                    return CategoryListItem(
                      title: _category.name,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ListPage(
                            title: _category.name,
                            description: _category.description,
                            body: PodcastList(
                              showTitle: false,
                              podcastEvent: LoadPodcasts(categoryId: _category.id),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return WhoopsWidget(
                  message: S.of(context).no_data_found,
                  onPressed: () => _podcastCategoryBloc.add(LoadPodcastCategories()),
                );
              }
            } else if (state is LoadingPodcastCategoryState) {
              return CategoryList(
                itemCount: 8,
                itemBuilder: (BuildContext context, int index) {
                  return CategoryListItemShimmer();
                },
              );
            } else if (state is ErrorPodcastCategoryState) {
              return WhoopsWidget(
                message: state.error,
                onPressed: () => _podcastCategoryBloc.add(LoadPodcastCategories()),
              );
            } else {
              return WhoopsWidget(
                message: S.of(context).no_data_found,
                onPressed: () => _podcastCategoryBloc.add(LoadPodcastCategories()),
              );
            }
          },
        ),
      ),
    );
  }
}
