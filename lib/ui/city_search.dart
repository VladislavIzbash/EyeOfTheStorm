import 'package:eye_of_the_storm/data/weather.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev;

import 'package:eye_of_the_storm/data/city_search.dart' as cities;

class CitySearchPage extends StatefulWidget {
  const CitySearchPage({Key? key}) : super(key: key);

  @override
  State<CitySearchPage> createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage> {
  final _searchFocus = FocusNode();
  final _searchController = TextEditingController();

  Future<List<cities.SearchResult>> cityList = Future.value([]);

  @override
  void initState() {
    super.initState();
    _searchFocus.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchCities() {
    if (_searchController.text.isEmpty) {
      return;
    }

    setState(() {
      cityList = cities.searchCities(_searchController.text, 20);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: TextField(
          focusNode: _searchFocus,
          controller: _searchController,
          onEditingComplete: _fetchCities,
          style: const TextStyle(fontSize: 20),
          decoration: const InputDecoration(
            hintText: 'Введите город',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _fetchCities,
          ),
        ],
      ),
      body: FutureBuilder<List<cities.SearchResult>>(
        future: cityList,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            dev.log('Error: ${snapshot.error}');
            return const Center(child: Text('Не удалось получить результаты'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var item = snapshot.data![index];
              return GestureDetector(
                child: ListTile(
                  title: Text('${item.city} - ${item.country}'),
                ),
                onTap: () {
                  var weather = context.read<WeatherModel>();
                  weather.currentCity = item.city;
                  weather.addFavoriteCity(item.city);
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
    );
  }
}