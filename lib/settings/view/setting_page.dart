import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/weather/models/weather.dart';

import '../../weather/cubit/weather_cubit.dart';

class SettingPage extends StatelessWidget {
  const SettingPage._();

  static Route get route => MaterialPageRoute<void>(
        builder: (_) => const SettingPage._(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          BlocBuilder<WeatherCubit, WeatherState>(
            buildWhen: (previous, current) =>
                previous.temperatureUnits != current.temperatureUnits,
            builder: (context, state) {
              return ListTile(
                title: const Text('Temperature Units'),
                isThreeLine: true,
                subtitle: const Text('Use metric measurements for temperature'),
                trailing: Switch(
                  value: state.temperatureUnits.isCelsius,
                  onChanged: (_) {
                    context.read<WeatherCubit>().toggleUnits();
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
