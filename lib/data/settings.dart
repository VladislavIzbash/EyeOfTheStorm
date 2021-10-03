import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TempUnit { celsius, fahrenheit }
enum SpeedUnit { meterSecond, kmHour }
enum PressureUnit { mmHg, kpa }

class UnitSettings {
  final TempUnit temp;
  final SpeedUnit speed;
  final PressureUnit pressure;

  const UnitSettings(this.temp, this.speed, this.pressure);

  UnitSettings.fromPrefs(SharedPreferences prefs)
    : temp = prefs.getString('temp_unit') == 'F' ? TempUnit.fahrenheit : TempUnit.celsius,
      speed = prefs.getString('speed_unit') == 'km_h' ? SpeedUnit.meterSecond : SpeedUnit.kmHour,
      pressure = prefs.getString('pressure_unit') == 'kpa' ? PressureUnit.kpa : PressureUnit.mmHg;

  void save(SharedPreferences prefs) {
    prefs.setString('temp_unit', temp == TempUnit.celsius ? 'C' : 'F');
    prefs.setString('speed_unit', speed == SpeedUnit.kmHour ? 'km_h' : 'm_s');
    prefs.setString('pressure_unit', pressure == PressureUnit.kpa ? 'kpa' : 'mm_hg');
  }

  String formatTemp(double tempC) {
    if (temp == TempUnit.celsius) {
      return '${tempC.round()} °C';
    } else {
      var tempF = tempC * 9 / 5 + 32;
      return '${tempF.round()} °F';
    }
  }

  String formatSpeed(double meterS) {
    if (speed == SpeedUnit.meterSecond) {
      return '$meterS м/с';
    } else {
      return '${meterS * 3.6} м/с';
    }
  }

  String formatPressure(int mgHg) {
    if (pressure == PressureUnit.mmHg) {
      return '$mgHg мм.рт.ст.';
    } else {
      return '${(mgHg / 7.501).round()} кПа';
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