import 'package:flutter/foundation.dart';
import 'package:async/async.dart';

import 'weather_api.dart' as api;

class WeatherModel extends ChangeNotifier {
  final _weatherCache = AsyncCache<api.WeatherForecast>(const Duration(minutes: 5));

  String _currentCity = 'Санкт-Петербург';

  String get currentCity => _currentCity;
  set currentCity(String city) {
    if (_currentCity != city) {
      _currentCity = city;
      _weatherCache.invalidate();
      notifyListeners();
    }
  }

  Future<api.WeatherForecast> fetchWeatherForecast() => _weatherCache.fetch(() {
    return api.fetchWeatherForecast(currentCity);
  });
}
