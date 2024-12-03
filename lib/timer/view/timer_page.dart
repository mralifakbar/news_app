import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/ticker.dart';
import 'package:news_app/timer/bloc/timer_bloc.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(ticker: const Ticker()),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Timer')),
      body: const Stack(
        children: [
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100),
                child: Center(
                  child: TimerText(),
                ),
              ),
              LocalActions()
            ],
          )
        ],
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return Text('$minutesStr:$secondsStr',
        style: Theme.of(context).textTheme.displayLarge);
  }
}

class LocalActions extends StatelessWidget {
  const LocalActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ...switch (state) {
            TimerInitial() => [
                FloatingActionButton(
                    onPressed: () =>
                        context.read<TimerBloc>().add(const TimerStarted(60)),
                    child: const Icon(Icons.play_arrow)),
              ],
            TimerRunInProgress() => [
                FloatingActionButton(
                  child: const Icon(Icons.pause),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerPaused()),
                ),
                FloatingActionButton(
                  child: const Icon(Icons.replay),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerReset()),
                ),
              ],
            TimerRunPause() => [
                FloatingActionButton(
                  child: const Icon(Icons.play_arrow),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerResumed()),
                ),
                FloatingActionButton(
                  child: const Icon(Icons.replay),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerReset()),
                ),
              ],
            TimerRunComplete() => [
                FloatingActionButton(
                  child: const Icon(Icons.replay),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerReset()),
                ),
              ]
          }
        ]);
      },
    );
  }
}

class Background extends StatelessWidget {
  const Background({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade500,
          ],
        ),
      ),
    );
  }
}
