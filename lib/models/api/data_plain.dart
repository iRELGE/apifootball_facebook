import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:kooramd/constants.dart';

class DataPlain {
  Future<dynamic> getDataMatchApi(
      {var dateFrom, var dateTo, var idMatch}) async {
    http.Response response = await http.get(
      'https://apiv2.apifootball.com/?action=get_events&from=$dateFrom&to=$dateTo&match_id=$idMatch&APIkey=$apiKey',
      headers: {'Accept': 'application/json'},
    );

    //  print(
    //"https://apiv2.apifootball.com/?action=get_events&from=$dateFrom&to=$dateTo&match_id=$idMatch&APIkey=$apiKey");

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

  Future<dynamic> getLineups({var idMatch}) async {
    http.Response response = await http.get(
      'https://apiv2.apifootball.com/?action=get_lineups&match_id=$idMatch&APIkey=$apiKey',
      headers: {'Accept': 'application/json'},
    );
//
//    print(
//        "https://apiv2.apifootball.com/?action=get_lineups&match_id=$idMatch&APIkey=$apiKey");

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
}
