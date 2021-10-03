import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:eye_of_the_storm/data/weather.dart';
import 'package:eye_of_the_storm/data/weather_api.dart';
import 'package:eye_of_the_storm/data/settings.dart';
import 'package:eye_of_the_storm/ui/weather_icons.dart';

class HourlyForecast extends StatelessWidget {
  final bool _expanded;

  const HourlyForecast({required bool expanded, Key? key})
      : _expanded = expanded,
        super(key: key);

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

            if (_expanded) {
              return _buildExpanded(context, snapshot.data!);
            } else {
              return _buildCollapsed(context, snapshot.data!);
            }
          },
        ),
      ],
    );
  }
}

Widget _buildCollapsed(BuildContext context, WeatherForecast forecast) {
  var units = context.select<SettingsModel, UnitSettings>((s) => s.units);

  return Column(
    children: [
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WeatherCard(forecast.hourly[0], units),
              _WeatherCard(forecast.hourly[6], units),
              _WeatherCard(forecast.hourly[12], units),
              _WeatherCard(forecast.hourly[18], units),
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
      ),
    ],
  );
}

Widget _buildExpanded(BuildContext context, WeatherForecast forecast) {
  var units = context.select<SettingsModel, UnitSettings>((s) => s.units);

  var date = forecast.current.date;
  return Column(
    children: [
      Text(
        '${date.day} ${_months[date.month]}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _WeatherCard(forecast.hourly[0], units),
          _WeatherCard(forecast.hourly[6], units),
          _WeatherCard(forecast.hourly[12], units),
          _WeatherCard(forecast.hourly[18], units),
        ],
      ),
      const SizedBox(height: 10),
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        padding: const EdgeInsets.all(8),
        children: [
          _WeatherParamCard(
            const AssetImage('assets/images/icons/temperature.png'),
            units.formatTemp(forecast.current.temp),
          ),
          _WeatherParamCard(
            const AssetImage('assets/images/icons/humidity.png'),
            '${forecast.current.humidity}%',
          ),
          _WeatherParamCard(
            const AssetImage('assets/images/icons/wind.png'),
            units.formatSpeed(forecast.current.windSpeed),
          ),
          _WeatherParamCard(
            const AssetImage('assets/images/icons/pressure.png'),
            units.formatPressure(forecast.current.pressure),
          ),
        ],
      ),
    ],
  );
}

class _WeatherParamCard extends StatelessWidget {
  final ImageProvider image;
  final String text;

  const _WeatherParamCard(this.image, this.text);

  @override
  Widget build(BuildContext context) {
    var iconTint = Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white;

    return Card(
      elevation: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: image, color: iconTint, width: 20, height: 20),
          const SizedBox(width: 5),
          Text(text),
        ],
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final Weather _weather;
  final UnitSettings _units;

  const _WeatherCard(this._weather, this._units);

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

    return Neumorphic(
      // elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          children: [
            Text(DateFormat('HH:mm').format(_weather.date)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: img,
            ),
            Text(_units.formatTemp(_weather.temp)),
          ],
        ),
      ),
    );
  }
}

const _months = {
  DateTime.january: 'января',
  DateTime.february: 'февраля',
  DateTime.march: 'марта',
  DateTime.april: 'апреля',
  DateTime.may: 'мая',
  DateTime.june: 'июня',
  DateTime.july: 'июля',
  DateTime.august: 'августа',
  DateTime.september: 'сентября',
  DateTime.october: 'октября',
  DateTime.november: 'ноября',
  DateTime.december: 'декабря',
};

