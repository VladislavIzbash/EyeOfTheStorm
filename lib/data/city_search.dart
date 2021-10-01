import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SearchResult {
  String city;
  String country;

  SearchResult(this.city, this.country);

  @override
  bool operator==(o) => o is SearchResult && city == o.city && country == o.country;

  @override
  int get hashCode => city.hashCode ^ country.hashCode;

}

Future<List<SearchResult>> searchCities(String query, int maxRows) async {
  var url = Uri.http('api.geonames.org', '/searchJSON', {
    'q': query,
    'maxRows': maxRows.toString(),
    'lang': 'ru',
    'fuzzy': '1',
    'username': dotenv.env['GEONAMES_KEY'],
  });

  http.Response resp = await http.get(url);
  var json = jsonDecode(resp.body);

  if (resp.statusCode != 200) {
    throw Exception(json['status']['message']);
  }

  return (json['geonames'] as List)
      .where((geoname) => geoname['countryName'] != null)
      .map((geoname) => SearchResult(geoname['name'], geoname['countryName']))
      .toSet()
      .toList();
}