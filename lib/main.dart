import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:news_app/app.dart';
import 'package:news_app/simple_bloc_observer.dart';

void main(List<String> args) {
  Bloc.observer = const SimpleBlocObserver();

  runApp(const App());
}
