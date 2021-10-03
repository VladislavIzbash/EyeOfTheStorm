import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import 'package:eye_of_the_storm/data/weather.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var weather = context.watch<WeatherModel>();
    var favorites = weather.favoriteCities;

    return Scaffold(
      appBar: NeumorphicAppBar(
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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: Neumorphic(
                style: NeumorphicStyle(
                  color: NeumorphicTheme.variantColor(context),
                  depth: -5,
                ),
                child: ListTile(
                  title: Text(favorites[index]),
                  trailing: NeumorphicButton(
                    style: NeumorphicStyle(
                      color: NeumorphicTheme.accentColor(context).withOpacity(0.2),
                    ),
                    child: const Icon(Icons.close),
                    onPressed: () {
                      context.read<WeatherModel>().removeFavoriteCity(favorites[index]);
                    },
                  ),
                ),
              ),
              onTap: () {
                context.read<WeatherModel>().currentCity = favorites[index];
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}
