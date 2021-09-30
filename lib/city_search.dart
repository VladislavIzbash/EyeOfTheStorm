import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

Future<List<String>> fetchCities(String query, int maxRows) async {
  var username = await rootBundle.loadString('geonames_key');
  var url = Uri.http('api.geonames.org', '/searchJSON', {
    'q': query,
    'maxRows': maxRows.toString(),
    'lang': 'ru',
    'fuzzy': '1',
    'username': username,
  });

  http.Response resp = await http.get(url);
  var json = jsonDecode(resp.body);

  if (resp.statusCode != 200) {
    throw Exception(json['status']['message']);
  }

  return (json['geonames'] as List)
      .map((geoname) => "${geoname['name']} - ${geoname['countryName']}")
      .toSet()
      .toList();
}