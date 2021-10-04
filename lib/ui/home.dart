import 'package:eye_of_the_storm/data/weather.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev;

import 'package:eye_of_the_storm/data/weather_api.dart';
import 'package:eye_of_the_storm/ui/hourly_forecast.dart';
import 'package:eye_of_the_storm/data/settings.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _EotsDrawer(),
      body: SlidingUpPanel(
        maxHeight: 350,
        minHeight: 230,
        padding: const EdgeInsets.all(5),
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        panel: const HourlyForecast(expanded: true),
        collapsed: Container(
          color: Theme.of(context).backgroundColor,
          child: const HourlyForecast(expanded: false),
        ),
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
                _CurrentTemp(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EotsDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Избранное'),
                onTap: () => Navigator.pushNamed(context, '/favorites'),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('О приложении'),
                  onTap: () => Navigator.pushNamed(context, '/about')
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrentTemp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var weather = context.watch<WeatherModel>();
    var units = context.select<SettingsModel, UnitSettings>((w) => w.units);

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
              units.formatTemp(snapshot.data!.current.temp),
              style: const TextStyle(fontSize: 50, color: Colors.white),
            ),
            Text(
              '${date.day} ${_shortMonths[date.month]} ${date.year}г.',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        );
      },
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

const _shortMonths = {
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

