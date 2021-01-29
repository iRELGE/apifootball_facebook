import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:kooramd/constants.dart';

Future<dynamic> getDataCounties() async {
  http.Response response = await http.get(
    'https://apiv2.apifootball.com/?action=get_countries&APIkey=$apiKey',
    headers: {'Accept': 'application/json'},
  );

  //   print("https://apiv2.apifootball.com/?action=get_countries&APIkey=$apiKey");

  try {
    if (response.statusCode == 200) {
      var leagueData = json.decode(response.body);
      return leagueData;
    } else {
      print('Error Conecting to server : ${response.statusCode}');
    }
  } catch (e) {
    print('Error : $e');
  }
}

Future<dynamic> getDataCompetition({var idCountry}) async {
  http.Response response = await http.get(
    'https://apiv2.apifootball.com/?action=get_leagues&country_id=$idCountry&APIkey=$apiKey',
    headers: {'Accept': 'application/json'},
  );

  //   print("https://apiv2.apifootball.com/?action=get_leagues&country_id=$idCountry&APIkey=$apiKey");

  try {
    if (response.statusCode == 200) {
      var leagueData = json.decode(response.body);
      return leagueData;
    } else {
      print('Error Conecting to server : ${response.statusCode}');
    }
  } catch (e) {
    print('Error Plan: $e');
  }
}
