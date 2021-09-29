import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class WeekReportPage extends StatelessWidget {
  const WeekReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: const Text('Прогноз на неделю'),
      ),
      body: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            _WeatherDayReport(),
            _WeatherDayReport(),
            _WeatherDayReport(),
          ],
        ),
    );
  }
}

class _WeatherDayReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lightGradient = [
      Color.fromARGB(255, 205, 218, 245),
      Color.fromARGB(255, 160, 190, 255),
    ];
    var darkGradient = [
      Color.fromARGB(255, 35, 59, 112),
      Color.fromARGB(255, 16, 32, 66),
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.light ? lightGradient : darkGradient,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '23 сентября',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Image(
                  image: AssetImage('assets/images/weather/cloudy_rain.png'),
                  width: 100,
                  height: 100,
                ),
              ),
              _WeatherParam(
                image: AssetImage('assets/images/icons/thermometer.png'),
                text: '10 °C',
              ),
              _WeatherParam(
                image: AssetImage('assets/images/icons/wind.png'),
                text: '9 м/с',
              ),
              _WeatherParam(
                image: AssetImage('assets/images/icons/waterdrop.png'),
                text: '87%',
              ),
              _WeatherParam(
                image: AssetImage('assets/images/icons/pressure.png'),
                text: '761 мм.рт.ст',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherParam extends StatelessWidget {
  final ImageProvider image;
  final String text;

  const _WeatherParam({required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    var imageTint = Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white;

    return ListTile(
      dense: true,
      minLeadingWidth: 0,
      leading: Image(image: image, width: 20, height: 20, color: imageTint),
      title: Text(
        text,
        style: const TextStyle(fontSize: 17),
      ),
    );
  }
}

