import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:async/async.dart';

import 'package:eye_of_the_storm/data/weather_api.dart' as api;

class WeatherModel extends ChangeNotifier {
  final _weatherCache = AsyncCache<api.WeatherForecast>(const Duration(minutes: 5));

  String _currentCity = 'Санкт-Петербург';
  final Set<String> _favoriteCities = {};

  WeatherModel() {
    _favoriteCities.add(currentCity);
  }

  String get currentCity => _currentCity;
  set currentCity(String city) {
    if (_currentCity != city) {
      _currentCity = city;
      _weatherCache.invalidate();
      notifyListeners();
    }
  }

  get favoriteCities => UnmodifiableListView(_favoriteCities);

  Future<api.WeatherForecast> fetchWeatherForecast() => _weatherCache.fetch(() {
    return api.fetchWeatherForecast(currentCity);
  });

  void addFavoriteCity(String city) {
    _favoriteCities.add(city);
    notifyListeners();
  }

  void removeFavoriteCity(String city) {
    _favoriteCities.remove(city);
    notifyListeners();
  }
}
