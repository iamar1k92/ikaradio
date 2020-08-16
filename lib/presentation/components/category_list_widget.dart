import 'package:base/data/models/category.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/presentation/blocs/category/bloc.dart';
import 'package:base/presentation/blocs/language/bloc.dart';
import 'package:base/presentation/blocs/radio/radio_event.dart';
import 'package:base/presentation/components/category/category_list.dart';
import 'package:base/presentation/components/category/category_list_item.dart';
import 'package:base/presentation/components/category/category_list_item_shimmer.dart';
import 'package:base/presentation/components/whoops_widget.dart';
import 'package:base/presentation/components/radio/radio_list.dart';
import 'package:base/presentation/pages/list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryListWidget extends StatefulWidget {
  @override
  _CategoryListWidgetState createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> with AutomaticKeepAliveClientMixin<CategoryListWidget> {
  final CategoryBloc _categoryBloc = CategoryBloc();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _categoryBloc.add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<LanguageBloc, LanguageState>(
      listener: (BuildContext context, LanguageState state) {
        _categoryBloc.add(LoadCategories());
      },
      child: BlocProvider<CategoryBloc>(
        create: (BuildContext context) => _categoryBloc,
        child: BlocBuilder<CategoryBloc, CategoryState>(
          bloc: _categoryBloc,
          builder: (BuildContext context, CategoryState state) {
            if (state is LoadingCategoryState) {
              return CategoryListItemShimmer();
            } else if (state is LoadedCategoryState) {
              if (state.categories.length > 0) {
                return CategoryList(
                  itemCount: state.categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    Category _category = state.categories[index];
                    return CategoryListItem(
                      title: _category.name,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ListPage(
                            title: _category.name,
                            description: _category.description,
                            body: RadioList(
                              showTitle: false,
                              radioEvent: LoadRadios(categoryId: _category.id),
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
                  onPressed: () => _categoryBloc.add(LoadCategories()),
                );
              }
            } else if (state is LoadingCategoryState) {
              return CategoryList(
                itemCount: 8,
                itemBuilder: (BuildContext context, int index) {
                  return CategoryListItemShimmer();
                },
              );
            } else if (state is ErrorCategoryState) {
              return WhoopsWidget(
                message: state.error,
                onPressed: () => _categoryBloc.add(LoadCategories()),
              );
            } else {
              return WhoopsWidget(
                message: S.of(context).no_data_found,
                onPressed: () => _categoryBloc.add(LoadCategories()),
              );
            }
          },
        ),
      ),
    );
  }
}
