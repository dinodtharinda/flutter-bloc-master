import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_master/features/blog/domain/usecases/upload_blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final  UploadBlog uploadBlog;
  BlogBloc({required this.uploadBlog}) : super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));

    on<BlogUpload>(_onBlogUpload);
  }

  FutureOr<void> _onBlogUpload(
      BlogUpload event, Emitter<BlogState> emit) async {
    final res = await uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogSuccess()),
    );
  }
}
