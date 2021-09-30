import 'package:flutter/material.dart';
import 'city_search.dart' as cities;

class CitySearchPage extends StatefulWidget {
  const CitySearchPage({Key? key}) : super(key: key);

  @override
  State<CitySearchPage> createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage> {
  final searchFocus = FocusNode();
  final searchController = TextEditingController();

  Future<List<String>> cityList = Future.value([]);

  @override
  void initState() {
    super.initState();
    searchFocus.requestFocus();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _fetchCities() {
    if (searchController.text.isEmpty) {
      return;
    }

    setState(() {
      cityList = cities.fetchCities(searchController.text, 20);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: TextField(
          focusNode: searchFocus,
          controller: searchController,
          onEditingComplete: _fetchCities,
          style: const TextStyle(fontSize: 20),
          decoration: const InputDecoration(
            hintText: 'Город',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _fetchCities,
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: cityList,
        builder: (c, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error!}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.separated(
            separatorBuilder: (c, index) => const Divider(),
            itemCount: snapshot.data!.length,
            itemBuilder: (c, index) {
              return ListTile(
                title: Text(snapshot.data![index]),
              );
            },
          );
        },
      ),
    );
  }
}