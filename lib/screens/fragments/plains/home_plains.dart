import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kooramd/models/api/data_plain.dart';

import 'package:kooramd/widgets/card_player.dart';
import 'package:kooramd/widgets/lives_widgets.dart';
import 'package:kooramd/widgets/widgets_facebook.dart' as WidgetesAdmob;

class HomePlains extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final date_match;
  // ignore: non_constant_identifier_names
  final uid_match;

  // ignore: non_constant_identifier_names
  HomePlains({@required this.date_match, @required this.uid_match});

  @override
  _HomePlainsState createState() => _HomePlainsState();
}

class _HomePlainsState extends State<HomePlains> {
  DataPlain dataPlain = DataPlain();

  var nameCoachHome = '';
  Map<String, dynamic> mMapHomeLineup = {};
  List<CardPlayer> mMapHomeSubstitutes = [];
  List<CardPlayer> mMapHomeMissingPlayers = [];

  Future<void> getLineupe() async {
    final mRespons = await dataPlain.getLineups(idMatch: widget.uid_match);

    try {
      var substitutes =
          mRespons[widget.uid_match]['lineup']['home']['substitutes'];
      for (var sub in substitutes) {
        setState(() {
          mMapHomeSubstitutes.add(CardPlayer(
              namePlayer: sub['lineup_player'],
              numberPlayer: sub['lineup_number']));
        });
      }
    } catch (e) {}

    try {
      var startingLineups =
          mRespons[widget.uid_match]['lineup']['home']['starting_lineups'];
      for (var sub in startingLineups) {
        setState(() {
          mMapHomeLineup.addAll({
            'player${sub['lineup_position']}': sub['lineup_player'],
            'number${sub['lineup_position']}': sub['lineup_number'],
          });
        });
      }
    } catch (e) {}

    try {
      var missingPlayers =
          mRespons[widget.uid_match]['lineup']['home']['missing_players'];
      for (var sub in missingPlayers) {
        setState(() {
          mMapHomeMissingPlayers.add(CardPlayer(
              namePlayer: sub['lineup_player'],
              numberPlayer: sub['lineup_number']));
        });
      }
    } catch (e) {}

    try {
      setState(() {
        nameCoachHome =
            mRespons[0]['lineup']['home']['coach'][0]['lineup_player'];
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
          nameBoss: '$nameCoachHome',
        ),
        //Plain and Stadium
        CardStadium(mMap: mMapHomeLineup),
        //Ads Native
        WidgetesAdmob.showNativeFacebook(),
        //substitutions
        CardSubstitutions(mList: mMapHomeSubstitutes),
        //Missing Players
        CardMissingPlayer(mList: mMapHomeMissingPlayers),
      ],
    );
  }
}
