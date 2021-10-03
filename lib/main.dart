import 'package:eye_of_the_storm/data/weather.dart';
import 'package:eye_of_the_storm/ui/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:eye_of_the_storm/ui/home.dart';
import 'package:eye_of_the_storm/ui/weekly_forecast.dart';
import 'package:eye_of_the_storm/ui/city_search.dart';
import 'package:eye_of_the_storm/data/settings.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  await SettingsModel.initPrefs();

  runApp(MultiProvider(
    providers: [
      Provider<WeatherModel>(create: (context) => WeatherModel()),
      Provider<SettingsModel>(create: (context) => SettingsModel()),
    ],
    child: const EotsApp(),
  ));
}

class EotsApp extends StatelessWidget {
  const EotsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const lightBackground = Color.fromARGB(255, 226, 235, 255);
    const darkBackground = Color.fromARGB(255, 12, 22, 43);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: lightBackground,
        backgroundColor: lightBackground,
        cardColor: lightBackground,
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: lightBackground,
        ),
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: darkBackground,
        backgroundColor: darkBackground,
        cardColor: darkBackground,
        brightness: Brightness.dark,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
          )
        ),
      ),
      title: 'Eye of the storm',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/week': (context) => const WeeklyForecastPage(),
        '/cities': (context) => const CitySearchPage(),
        '/favorites': (context) => const FavoritesPage(),
      },
    );
  }
}
