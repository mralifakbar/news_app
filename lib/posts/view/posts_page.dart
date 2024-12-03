import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/posts/bloc/post_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/posts/view/posts_list.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostBloc(httpClient: http.Client())..add(PostFetched()),
      child: const PostsList(),
    );
  }
}
