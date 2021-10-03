import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eye_of_the_storm/data/weather.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var weather = context.watch<WeatherModel>();
    var favorites = weather.favoriteCities;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: const Text('Избранные города'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/cities'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          var isCurrent = weather.currentCity == favorites[index];

          return GestureDetector(
            child: ListTile(
              title: Text(favorites[index]),
              trailing: isCurrent ? null : IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  context.read<WeatherModel>().removeFavoriteCity(favorites[index]);
                },
              ),
            ),
            onTap: () {
              context.read<WeatherModel>().currentCity = favorites[index];
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
