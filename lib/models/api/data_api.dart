import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:kooramd/constants.dart';

class DataApi {
  Future<dynamic> getDataLeaguesApi(
      {var dateFrom, var dateTo, var idLuega}) async {
    http.Response response = await http.get(
      'https://apiv2.apifootball.com/?action=get_events&from=$dateFrom&to=$dateTo&league_id=$idLuega&APIkey=$apiKey',
      headers: {'Accept': 'application/json'},
    );

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
}

/**
    const id_match = '194200';
    const liveMatches =
    'https://apiv2.apifootball.com/?action=get_events&match_id=$id_match&APIkey=$apiKey';'
 **/
