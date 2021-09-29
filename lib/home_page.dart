import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pc = PanelController();

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
                    'Eye of the storm',
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
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('О приложении'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      body: SlidingUpPanel(
        controller: pc,
        minHeight: 50,
        maxHeight: 230,
        padding: const EdgeInsets.all(5),
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        panel: _DailyReportSheet(),
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
                      const Text(
                        'Санкт-Петербург',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      _ExtrudedButton(
                        child: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  '10 °C',
                  style: TextStyle(fontSize: 50, color: Colors.white),
                ),
                const Text(
                  '23 cент. 2021',
                  style: TextStyle(fontSize: 20, color: Colors.white),
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

class _DailyReportSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 5,
          width: 50,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _WeatherCard(),
            _WeatherCard(),
            _WeatherCard(),
            _WeatherCard(),
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
  }
}

class _WeatherCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [
            Text('12:00'),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Image(
                image: AssetImage('assets/images/weather/cloudy_rain.png'),
                width: 50,
                height: 50,
              ),
            ),
            Text('10 °C'),
          ],
        ),
      ),
    );
  }
}
