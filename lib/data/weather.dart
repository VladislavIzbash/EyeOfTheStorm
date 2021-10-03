import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:async/async.dart';

import 'package:eye_of_the_storm/data/weather_api.dart' as api;
import 'package:eye_of_the_storm/data/settings.dart';

class WeatherModel extends ChangeNotifier {
  final _weatherCache = AsyncCache<api.WeatherForecast>(const Duration(minutes: 5));

  String _currentCity;
  final Set<String> _favoriteCities;

  WeatherModel()
    : _currentCity = SettingsModel.prefs.getString('current_city') ?? 'Санкт-Петербург',
      _favoriteCities = (SettingsModel.prefs.getStringList('favorite_cities') ?? []).toSet();

  String get currentCity => _currentCity;
  set currentCity(String city) {
    if (_currentCity != city) {
      _currentCity = city;
      _weatherCache.invalidate();
      SettingsModel.prefs.setString('current_city', city);

      notifyListeners();
    }
  }

  UnmodifiableListView get favoriteCities => UnmodifiableListView(_favoriteCities);

  Future<api.WeatherForecast> fetchWeatherForecast() => _weatherCache.fetch(() {
    return api.fetchWeatherForecast(currentCity);
  });

  void addFavoriteCity(String city) {
    _favoriteCities.add(city);
    SettingsModel.prefs.setStringList('favorite_cities', _favoriteCities.toList(growable: false));

    notifyListeners();
  }

  void removeFavoriteCity(String city) {
    _favoriteCities.remove(city);
    SettingsModel.prefs.setStringList('favorite_cities', _favoriteCities.toList(growable: false));

    notifyListeners();
  }
}
