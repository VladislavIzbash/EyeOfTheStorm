import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import 'package:eye_of_the_storm/data/settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settings = context.watch<SettingsModel>();

    return Scaffold(
      appBar: NeumorphicAppBar(
        title: const Text('Настройки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Единицы измерения',
              style: NeumorphicTheme.currentTheme(context).textTheme.subtitle1!,
            ),
            const SizedBox(height: 20),
            Neumorphic(
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(30)),
              ),
              child: Column(
                children: [
                  _UnitToggle(
                    title: 'Температура',
                    first: '°C',
                    second: '°F',
                    selectedIndex: settings.units.temp == TempUnit.celsius ? 0 : 1,
                    onChanged: (index) {
                      var units = context.read<SettingsModel>().units;
                      context.read<SettingsModel>().units = UnitSettings(
                        index == 0 ? TempUnit.celsius : TempUnit.fahrenheit,
                        units.speed,
                        units.pressure,
                      );
                    },
                  ),
                  const Divider(),
                  _UnitToggle(
                    title: 'Сила ветра',
                    first: 'м/c',
                    second: 'км/ч',
                    selectedIndex: settings.units.speed == SpeedUnit.meterSecond ? 0 : 1,
                    onChanged: (index) {
                      var units = context.read<SettingsModel>().units;
                      context.read<SettingsModel>().units = UnitSettings(
                        units.temp,
                        index == 0 ? SpeedUnit.meterSecond : SpeedUnit.kmHour,
                        units.pressure,
                      );
                    },
                  ),
                  const Divider(),
                  _UnitToggle(
                    title: 'Давление',
                    first: 'мм.рт.ст.',
                    second: 'кПа',
                    selectedIndex: settings.units.pressure == PressureUnit.mmHg ? 0 : 1,
                    onChanged: (index) {
                      var units = context.read<SettingsModel>().units;
                      context.read<SettingsModel>().units = UnitSettings(
                        units.temp,
                        units.speed,
                        index == 0 ? PressureUnit.mmHg : PressureUnit.kpa,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitToggle extends StatelessWidget {
  final String title;
  final String first;
  final String second;
  final int selectedIndex;
  final Function(int) onChanged;

  const _UnitToggle({
    required this.title,
    required this.first,
    required this.second,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: NeumorphicToggle(
        height: 25,
        width: 130,
        selectedIndex: selectedIndex,
        thumb: Neumorphic(),
        onChanged: onChanged,
        children: [
          ToggleElement(
              background: Center(child: Text(first)),
              foreground: Neumorphic(
                style: NeumorphicStyle(
                  color: NeumorphicTheme.accentColor(context),
                ),
                child: Center(
                  child: Text(
                    first,
                    style: NeumorphicTheme.currentTheme(context).textTheme.subtitle2,
                  ),
                ),
              ),
          ),
          ToggleElement(
            background: Center(child: Text(second)),
            foreground: Neumorphic(
              style: NeumorphicStyle(
                color: NeumorphicTheme.accentColor(context),
              ),
              child: Center(
                child: Text(
                  second,
                  style: NeumorphicTheme.currentTheme(context).textTheme.subtitle2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

