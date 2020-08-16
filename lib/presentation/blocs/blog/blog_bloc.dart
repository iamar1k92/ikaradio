import 'dart:async';
import 'package:base/core/utils/exceptions/network_exceptions.dart';
import 'package:base/data/repositories/blog_repository.dart';
import 'package:base/data/responses/blog_response.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  BlogRepository _blogRepository = sl<BlogRepository>();

  BlogBloc() : super(InitialBlogState());

  @override
  Stream<BlogState> mapEventToState(BlogEvent event) async* {
    if (event is LoadBlogs) {
      yield* _mapLoadBlogsToState(event);
    } else if (event is Comment) {
      yield LoadingBlogState();
      yield* _mapCommentToState(event);
    } else if (event is DeleteComment) {
      yield LoadingBlogState();
      yield* _mapDeleteCommentToState(event);
    }
  }

  Stream<BlogState> _mapLoadBlogsToState(LoadBlogs event) async* {
    yield LoadingBlogState();
    try {
      BlogResponse _blogResponse = await _blogRepository.getBlogs(search: event.search, categoryId: event.categoryId, limit: event.limit);
      if (_blogResponse.error == null) {
        yield LoadedBlogState(blogs: _blogResponse.blogs);
      } else {
        yield ErrorBlogState(error: _blogResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorBlogState(error: e.message.toString());
    } catch (e) {
      yield ErrorBlogState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }

  Stream<BlogState> _mapCommentToState(Comment event) async* {
    yield LoadingBlogState();
    try {
      BlogResponse _blogResponse = await _blogRepository.comment(blogId: event.blogId, comment: event.comment);
      if (_blogResponse.error == null) {
        yield LoadedCommentsState(comments: _blogResponse.comments);
      } else {
        yield ErrorBlogState(error: _blogResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorBlogState(error: e.message.toString());
    } catch (e) {
      yield ErrorBlogState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }

  Stream<BlogState> _mapDeleteCommentToState(DeleteComment event) async* {
    yield LoadingBlogState();
    try {
      BlogResponse _blogResponse = await _blogRepository.deleteComment(commentId: event.commentId);
      if (_blogResponse.error == null) {
        yield LoadedCommentsState(comments: _blogResponse.comments);
      } else {
        yield ErrorBlogState(error: _blogResponse.error);
      }
    } on NetworkException catch (e) {
      yield ErrorBlogState(error: e.message.toString());
    } catch (e) {
      yield ErrorBlogState(error: S.current.an_unexpected_problem_has_occurred);
    }
  }
}
