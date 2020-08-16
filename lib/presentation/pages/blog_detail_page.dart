import 'package:base/core/utils/timeago.dart';
import 'package:base/data/models/blog.dart';
import 'package:base/data/models/blog_comment.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/presentation/blocs/blog/bloc.dart';
import 'package:base/presentation/blocs/user/user_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BlogDetailPage extends StatefulWidget {
  final Blog blog;

  const BlogDetailPage({Key key, @required this.blog}) : super(key: key);

  @override
  _BlogDetailPageState createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final BlogBloc _blogCommentBloc = BlogBloc();
  List<BlogComment> comments;

  @override
  void initState() {
    super.initState();
    comments = widget.blog.comments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: widget.blog.cover,
                placeholder: (context, url) => Container(
                  width: 40.0,
                  height: 40.0,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Text(widget.blog.categories.map((category) => category.name).toList().join(", "), style: Theme.of(context).textTheme.caption),
                  SizedBox(height: 5.0),
                  Text(widget.blog.title, style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.0),
                  Text(widget.blog.description, style: Theme.of(context).textTheme.caption),
                  SizedBox(height: 5.0),
                  Html(data: widget.blog.content)
                ],
              ),
              Text(S.of(context).comments, style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 10.0),
              if (BlocProvider.of<UserBloc>(context).user != null)
                BlocProvider(
                  create: (BuildContext context) => _blogCommentBloc,
                  child: BlocBuilder<BlogBloc, BlogState>(
                    builder: (BuildContext context, BlogState state) {
                      return FormBuilder(
                        key: _fbKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            FormBuilderTextField(
                              minLines: 3,
                              maxLines: 5,
                              attribute: "comment",
                              decoration: InputDecoration(
                                filled: false,
                                labelText: S.of(context).comment,
                                hintText: S.of(context).comment,
                              ),
                              keyboardType: TextInputType.multiline,
                              validators: [
                                FormBuilderValidators.required(errorText: S.of(context).this_field_cannot_be_empty),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            SizedBox(
                              width: double.infinity,
                              child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                padding: EdgeInsets.all(10.0),
                                onPressed: state is LoadingBlogState
                                    ? null
                                    : () {
                                        if (_fbKey.currentState.saveAndValidate()) {
                                          _blogCommentBloc.add(Comment(blogId: widget.blog.id, comment: _fbKey.currentState.fields['comment'].currentState.value));
                                          _fbKey.currentState.reset();
                                        }
                                      },
                                child: state is LoadingBlogState
                                    ? SizedBox(width: 18.0, height: 18.0, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                                    : Text(S.of(context).comment, style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(height: 15.0),
              if (comments.length > 0)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: comments.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    BlogComment _blogComment = comments[index];
                    return BlocProvider(
                      create: (BuildContext context) => BlogBloc(),
                      child: MultiBlocListener(
                        listeners: [
                          BlocListener(
                            bloc: _blogCommentBloc,
                            listener: (BuildContext context, BlogState state) {
                              if (state is LoadedCommentsState) {
                                setState(() {
                                  comments = state.comments;
                                });
                              }
                            },
                          ),
                          BlocListener<BlogBloc, BlogState>(
                            listener: (BuildContext context, BlogState state) {
                              if (state is LoadedCommentsState) {
                                setState(() {
                                  comments = state.comments;
                                });
                              }
                            },
                          ),
                        ],
                        child: BlocBuilder<BlogBloc, BlogState>(
                          builder: (BuildContext context, BlogState state) {
                            return Card(
                              margin: EdgeInsets.only(bottom: 10.0),
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(_blogComment.author),
                                    SizedBox(width: 15.0),
                                    Text(
                                      TimeAgo().format(_blogComment.createdAt),
                                      style: Theme.of(context).textTheme.caption,
                                    )
                                  ],
                                ),
                                subtitle: Text(_blogComment.comment),
                                trailing: BlocProvider.of<UserBloc>(context).user.id == _blogComment.authorId
                                    ? state is LoadingBlogState
                                        ? Container(
                                            margin: EdgeInsets.only(right: 10.0),
                                            child: SizedBox(width: 24.0, height: 24.0, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))))
                                        : IconButton(
                                            icon: Icon(FontAwesomeIcons.trash, color: Colors.redAccent.shade700, size: 18.0),
                                            onPressed: () => BlocProvider.of<BlogBloc>(context).add(DeleteComment(commentId: _blogComment.id)))
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                )
              else
                Text(S.of(context).no_data_found),
            ],
          ),
        ),
      ),
    );
  }
}
