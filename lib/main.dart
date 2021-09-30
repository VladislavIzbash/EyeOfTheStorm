import 'package:eye_of_the_storm/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';
import 'weekly_forecast_page.dart';
import 'city_search_page.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');

  runApp(ChangeNotifierProvider(
    create: (context) => WeatherModel(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.white,
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
        '/': (_) => const HomePage(),
        '/week': (_) => const WeeklyForecastPage(),
        '/cities': (_) => const CitySearchPage(),
      },
    );
  }
}
