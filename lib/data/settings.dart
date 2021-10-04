import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TempUnit { celsius, fahrenheit }
enum SpeedUnit { meterSecond, kmHour }
enum PressureUnit { mmHg, hPa }

class UnitSettings {
  final TempUnit temp;
  final SpeedUnit speed;
  final PressureUnit pressure;

  const UnitSettings(this.temp, this.speed, this.pressure);

  UnitSettings.fromPrefs(SharedPreferences prefs)
    : temp = prefs.getString('temp_unit') == 'F' ? TempUnit.fahrenheit : TempUnit.celsius,
      speed = prefs.getString('speed_unit') == 'km_h' ? SpeedUnit.kmHour : SpeedUnit.meterSecond,
      pressure = prefs.getString('pressure_unit') == 'hpa' ? PressureUnit.hPa : PressureUnit.mmHg;

  void save(SharedPreferences prefs) {
    prefs.setString('temp_unit', temp == TempUnit.celsius ? 'C' : 'F');
    prefs.setString('speed_unit', speed == SpeedUnit.kmHour ? 'km_h' : 'm_s');
    prefs.setString('pressure_unit', pressure == PressureUnit.hPa ? 'hpa' : 'mm_hg');
  }

  String formatTemp(double tempC) {
    if (temp == TempUnit.celsius) {
      return '${tempC.round()} °C';
    } else {
      return '${(tempC * 9 / 5 + 32).round()} °F';
    }
  }

  String formatSpeed(double meterS) {
    if (speed == SpeedUnit.meterSecond) {
      return '$meterS м/с';
    } else {
      return '${(meterS * 3.6).round()} м/с';
    }
  }

  String formatPressure(int hPa) {
    if (pressure == PressureUnit.hPa) {
      return '$hPa гПа';
    } else {
      return '${(hPa / 1.333).round()} мм.рт.ст.';
    }
  }
}

class SettingsModel extends ChangeNotifier {
  static late final SharedPreferences prefs;

  var _units = const UnitSettings(TempUnit.celsius, SpeedUnit.meterSecond, PressureUnit.mmHg);

  SettingsModel()
    : _units = UnitSettings.fromPrefs(prefs);

  UnitSettings get units => _units;

  set units(UnitSettings units) {
    _units = units;
    _units.save(prefs);
    notifyListeners();
  }

  static Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }
}