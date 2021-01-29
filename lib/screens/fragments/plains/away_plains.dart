import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kooramd/models/api/data_plain.dart';
import 'package:kooramd/widgets/card_player.dart';
import 'package:kooramd/widgets/lives_widgets.dart';
import 'package:kooramd/widgets/widgets_facebook.dart' as WidgetesAdmob;

class AwayPlains extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final date_match;
  // ignore: non_constant_identifier_names
  final uid_match;

  // ignore: non_constant_identifier_names
  AwayPlains({@required this.date_match, @required this.uid_match});

  @override
  _AwayPlainsState createState() => _AwayPlainsState();
}

class _AwayPlainsState extends State<AwayPlains> {
  DataPlain dataPlain = DataPlain();

  var nameCoachAway = '';
  Map<String, dynamic> mMapAwayLineup = {};
  List<CardPlayer> mMapAwaySubstitutes = [];
  List<CardPlayer> mMapAwayMissingPlayers = [];

  Future<void> getLineupe() async {
    final mRespons = await dataPlain.getLineups(idMatch: widget.uid_match);

    try {
      var substitutes =
          mRespons[widget.uid_match]['lineup']['away']['substitutes'];
      for (var sub in substitutes) {
        setState(() {
          mMapAwaySubstitutes.add(CardPlayer(
              namePlayer: sub['lineup_player'],
              numberPlayer: sub['lineup_number']));
        });
      }
    } catch (e) {}

    try {
      var startingLineups =
          mRespons[widget.uid_match]['lineup']['away']['starting_lineups'];
      for (var sub in startingLineups) {
        setState(() {
          mMapAwayLineup.addAll({
            'player${sub['lineup_position']}': sub['lineup_player'],
            'number${sub['lineup_position']}': sub['lineup_number'],
          });
        });
      }
    } catch (e) {}

    try {
      var missingPlayers =
          mRespons[widget.uid_match]['lineup']['away']['missing_players'];
      for (var sub in missingPlayers) {
        setState(() {
          mMapAwayMissingPlayers.add(CardPlayer(
              namePlayer: sub['lineup_player'],
              numberPlayer: sub['lineup_number']));
        });
      }
    } catch (e) {}
    try {
      setState(() {
        nameCoachAway =
            mRespons[0]['lineup']['away']['coach'][0]['lineup_player'];
      });
    } catch (e) {}
  }

  @override
  void initState() {
    getLineupe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Plan Match
        CardBoss(
          nameBoss: '$nameCoachAway',
        ),
        //Plain and Stadium
        CardStadium(mMap: mMapAwayLineup),
        //Ads Native
        WidgetesAdmob.showNativeFacebook(),
        //substitutions
        CardSubstitutions(mList: mMapAwaySubstitutes),
        //Missing Players
        CardMissingPlayer(mList: mMapAwayMissingPlayers),
      ],
    );
  }
}
