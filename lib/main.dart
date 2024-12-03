import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:news_app/app.dart';
import 'package:news_app/counter_observer.dart';

void main() {
  Bloc.observer = const CounterObserver();
  runApp(const CounterApp());
}
