import 'package:flutter/material.dart';

import 'home_page.dart';
import 'week_report_page.dart';

void main() => runApp(const MyApp());

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
        )
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
        '/week': (_) => const WeekReportPage(),
      },
    );
  }
}
