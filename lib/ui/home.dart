import 'package:eye_of_the_storm/data/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;

import 'package:eye_of_the_storm/data/weather_api.dart';
import 'package:eye_of_the_storm/ui/weather_icons.dart';
import 'package:eye_of_the_storm/ui/about.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Eye Of The Storm',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Настройки'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('Избранное'),
                  onTap: () => Navigator.pushNamed(context, '/favorites'),
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('О приложении'),
                  onTap: () => showDialog<void>(
                    context: context,
                    builder: (context) => const EotsAboutDialog(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SlidingUpPanel(
        minHeight: 35,
        maxHeight: 230,
        padding: const EdgeInsets.all(5),
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        panel: _HourlyForecastPanel(),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Theme.of(context).brightness == Brightness.light
                  ? const AssetImage('assets/images/home_page_bg_light.png')
                  : const AssetImage('assets/images/home_page_bg_dark.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(builder: (context) => _ExtrudedButton(
                        child: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      )),
                      Consumer<WeatherModel>(
                        builder: (context, weather, child) {
                          return Text(
                            weather.currentCity,
                            style: const TextStyle(fontSize: 20, color: Colors.white),
                          );
                        }
                      ),
                      _ExtrudedButton(
                        child: const Icon(Icons.add, color: Colors.white),
                        onPressed: () => Navigator.pushNamed(context, '/cities'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Consumer<WeatherModel>(
                  builder: (context, weather, child) {
                    return FutureBuilder<WeatherForecast>(
                      future: weather.fetchWeatherForecast(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          dev.log('Error: ${snapshot.error}');
                          return const Text(
                            'Не удалось получить данные',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator(color: Colors.white);
                        }
                        var date = snapshot.data!.current.date;
                        return Column(
                          children: [
                            Text(
                              '${snapshot.data!.current.temp.round()} °C',
                              style: const TextStyle(fontSize: 50, color: Colors.white),
                            ),
                            Text(
                              '${date.day} ${_months[date.month]} ${date.year}г.',
                              style: const TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

class _ExtrudedButton extends StatelessWidget {
  final Widget child;
  final NeumorphicButtonClickListener onPressed;

  const _ExtrudedButton({required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: const NeumorphicStyle(
        color: Colors.transparent,
        lightSource: LightSource(0, 0),
        shadowLightColor: Colors.black87,
        boxShape: NeumorphicBoxShape.circle(),
      ),
      child: child,
      onPressed: onPressed,
    );
  }
}

class _HourlyForecastPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var weather = context.watch<WeatherModel>();

    return Column(
      children: [
        Container(
          height: 5,
          width: 50,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 20),
        FutureBuilder<WeatherForecast>(
          future: weather.fetchWeatherForecast(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Не удалось получить данные');
            }
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _WeatherCard(snapshot.data!.hourly[0]),
                    _WeatherCard(snapshot.data!.hourly[6]),
                    _WeatherCard(snapshot.data!.hourly[12]),
                    _WeatherCard(snapshot.data!.hourly[18]),
                  ],
                ),
                const SizedBox(height: 10),
                TextButton(
                  style: ButtonStyle(shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      )
                  )),
                  child: const Text('Прогноз на неделю'),
                  onPressed: () => Navigator.pushNamed(context, '/week'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final Weather _weather;

  const _WeatherCard(this._weather);

  @override
  Widget build(BuildContext context) {
    var imgPath = weatherIcons[_weather.conditionCode];
    Widget img;
    if (imgPath != null) {
      img = Image(
        image: AssetImage(imgPath),
        width: 50,
        height: 50,
      );
    } else {
      img = SizedBox(
        width: 50,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Center(
            child: Text(_weather.conditionCode.toString()),
          ),
        ),
      );
    }

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          children: [
            Text(DateFormat('HH:mm').format(_weather.date)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: img,
            ),
            Text('${_weather.temp.round()} °C'),
          ],
        ),
      ),
    );
  }
}

const _months = {
  DateTime.january: 'янв.',
  DateTime.february: 'февр.',
  DateTime.march: 'марта',
  DateTime.april: 'апр.',
  DateTime.may: 'мая',
  DateTime.june: 'июня',
  DateTime.july: 'июля',
  DateTime.august: 'авг.',
  DateTime.september: 'сент.',
  DateTime.october: 'окт.',
  DateTime.november: 'ноября',
  DateTime.december: 'дек.',
};
