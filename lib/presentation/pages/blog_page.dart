import 'package:base/data/models/blog.dart';
import 'package:base/data/models/blog_category.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/presentation/blocs/blog/bloc.dart';
import 'package:base/presentation/blocs/blog_category/bloc.dart';
import 'package:base/presentation/blocs/language/bloc.dart';
import 'package:base/presentation/components/whoops_widget.dart';
import 'package:base/presentation/pages/blog_detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final BlogBloc _blogBloc = BlogBloc();
  final BlogCategoryBloc _blogCategoryBloc = BlogCategoryBloc();
  int categoryId;
  String search = "";
  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle;
  FocusNode _searchNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _blogBloc.add(LoadBlogs());
    _blogCategoryBloc.add(LoadBlogCategories());
    Future.delayed(Duration.zero, () {
      setState(() {
        _appBarTitle = Text(S.of(context).blogs);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            onPressed: _searchPressed,
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: BlocListener<LanguageBloc, LanguageState>(
            listener: (BuildContext context, LanguageState state) {
              _blogBloc.add(LoadBlogs(search: search, categoryId: categoryId));
              _blogCategoryBloc.add(LoadBlogCategories());
            },
            child: Column(
              children: <Widget>[
                Container(
                  height: 25.0,
                  child: BlocProvider(
                    create: (BuildContext context) => _blogCategoryBloc,
                    child: BlocBuilder(
                      bloc: _blogCategoryBloc,
                      builder: (BuildContext context, BlogCategoryState state) {
                        if (state is LoadedBlogCategoryState) {
                          return ListView.separated(
                            itemCount: state.categories.length,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (BuildContext context, int index) {
                              return SizedBox(width: 10.0);
                            },
                            itemBuilder: (BuildContext context, int index) {
                              BlogCategory _blogCategory = state.categories[index];
                              return RaisedButton(
                                color: categoryId == _blogCategory.id ? Theme.of(context).primaryColor : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  side: BorderSide(color: categoryId == _blogCategory.id ? Theme.of(context).primaryColor : Colors.black),
                                ),
                                onPressed: () {
                                  if (categoryId == _blogCategory.id) {
                                    setState(() {
                                      categoryId = null;
                                    });
                                    _blogBloc.add(LoadBlogs());
                                  } else {
                                    setState(() {
                                      categoryId = _blogCategory.id;
                                    });
                                    _blogBloc.add(LoadBlogs(categoryId: categoryId));
                                  }
                                },
                                child: Text(
                                  _blogCategory.name,
                                  style: TextStyle(color: categoryId == _blogCategory.id ? Colors.white : Colors.black),
                                ),
                              );
                            },
                          );
                        } else {
                          return SizedBox(height: 0);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Expanded(
                  child: BlocProvider(
                    create: (BuildContext context) => _blogBloc,
                    child: BlocBuilder(
                      bloc: _blogBloc,
                      builder: (BuildContext context, BlogState state) {
                        if (state is LoadedBlogState) {
                          if (state.blogs.length > 0) {
                            return ListView.builder(
                              itemCount: state.blogs.length,
                              itemBuilder: (BuildContext context, int index) {
                                Blog _blog = state.blogs[index];
                                return Card(
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  child: InkWell(
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BlogDetailPage(blog: _blog))),
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          CachedNetworkImage(
                                            imageUrl: _blog.cover,
                                            placeholder: (context, url) => Container(
                                              width: 40.0,
                                              height: 40.0,
                                              child: Center(child: CircularProgressIndicator()),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(_blog.categories.map((category) => category.name).toList().join(", "), style: Theme.of(context).textTheme.caption),
                                                SizedBox(height: 5.0),
                                                Text(_blog.title, style: Theme.of(context).textTheme.subtitle2),
                                                SizedBox(height: 5.0),
                                                Text(_blog.description, style: Theme.of(context).textTheme.caption)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return WhoopsWidget(
                              message: S.of(context).no_data_found,
                              onPressed: () => _blogBloc.add(LoadBlogs(search: search, categoryId: categoryId)),
                            );
                          }
                        } else if (state is ErrorBlogState) {
                          return WhoopsWidget(
                            message: state.error,
                            onPressed: () => _blogBloc.add(LoadBlogs(search: search, categoryId: categoryId)),
                          );
                        } else if (state is LoadingBlogState) {
                          return ListView.builder(
                            itemCount: 5,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300],
                                  highlightColor: Colors.grey[100],
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(width: double.infinity, height: 225.0, color: Colors.white),
                                        Container(
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(width: 150, height: 8.0, color: Colors.white),
                                              SizedBox(height: 5.0),
                                              Container(width: 100, height: 8.0, color: Colors.white),
                                              SizedBox(height: 5.0),
                                              Container(width: double.infinity, height: 25.0, color: Colors.white),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return WhoopsWidget(
                            message: S.of(context).no_data_found,
                            onPressed: () => _blogBloc.add(LoadBlogs(search: search, categoryId: categoryId)),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            )),
      ),
      bottomNavigationBar: SizedBox(height: kBottomNavigationBarHeight),
    );
  }

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = Icon(Icons.close);
        _appBarTitle = Expanded(
          child: TextField(
            focusNode: _searchNode,
            onSubmitted: (val) {
              if (val.isNotEmpty) {
                _blogBloc.add(LoadBlogs(search: val));
                setState(() {
                  categoryId = null;
                  search = val;
                });
              }
            },
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              filled: false,
              labelText: S.of(context).search,
              hintText: S.of(context).search,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 0, bottom: 20, top: 5, right: 15),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
          ),
        );
        _searchNode.requestFocus();
      } else {
        if (search.isNotEmpty) {
          _blogBloc.add(LoadBlogs());
        }
        _searchIcon = Icon(Icons.search);
        _appBarTitle = Text(S.of(context).blogs);
        setState(() {
          search = "";
        });
      }
    });
  }
}
