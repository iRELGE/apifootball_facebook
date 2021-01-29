import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:kooramd/models/api/data_plain.dart';

import 'package:kooramd/widgets/card_widget.dart';
import 'package:kooramd/widgets/widgets_facebook.dart' as WidgetesAdmob;
import '../../constants.dart';

class StaticScreen extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final uid_match;
  // ignore: non_constant_identifier_names
  final date_match;
  // ignore: non_constant_identifier_names
  StaticScreen({@required this.uid_match, @required this.date_match});

  @override
  _StaticScreenState createState() => _StaticScreenState();
}

class _StaticScreenState extends State<StaticScreen> {
  DataPlain dataPlain = DataPlain();

  List<ListGoals> mListGoals = [];
  List<ListCards> mListCards = [];

  Future<dynamic> getGoalsMatch() async {
    final mRespons = await dataPlain.getDataMatchApi(
        dateTo: widget.date_match,
        dateFrom: widget.date_match,
        idMatch: widget.uid_match);

    try {
      var badgeHome = await mRespons[0]['team_home_badge'];
      var badgeAway = await mRespons[0]['team_away_badge'];
      //Goal's
      var goalscorer = await mRespons[0]['goalscorer'];
      for (var goals in goalscorer) {
        setState(() {
          mListGoals.add(
            ListGoals(
              player_away: goals['away_scorer'],
              player_home: goals['home_scorer'],
              score: goals['score'],
              time: goals['time'],
              logoTeam:
                  '${goals['away_scorer'].toString().isEmpty ? badgeHome : badgeAway}',
            ),
          );
        });
      }

      //Card's
      var cardData = await mRespons[0]['cards'];
      for (var card in cardData) {
        setState(() {
          mListCards.add(ListCards(
            card: card['card'],
            home_fault: card['home_fault'],
            away_fault: card['away_fault'],
            time: card['time'],
            info: card['info'],
            logoTeam:
                '${card['away_fault'].toString().isEmpty ? badgeHome : badgeAway}',
          ));
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    getGoalsMatch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          CardGoals(mList: mListGoals),
          //Ads Native
          WidgetesAdmob.showNativeFacebook(),
          CardCards(
            mList: mListCards,
          ),
        ],
      ),
    );
  }
}

class CardCards extends StatelessWidget {
  final List<ListCards> mList;
  CardCards({@required this.mList});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shadowColor: Colors.black54.withOpacity(0.3),
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SvgPicture.asset(
                  'images/icon_rules.svg',
                  width: 22.0,
                  height: 22.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'Crads',
                  style: kStyleChoose_2,
                ),
              ],
            ),
          ),
          Column(
            children: mList,
          ),
        ],
      ),
    );
  }
}

class ListCards extends StatelessWidget {
  final logoTeam;
  final card;
  // ignore: non_constant_identifier_names
  final home_fault, away_fault;
  final time;
  final info;

  ListCards(
      {@required this.logoTeam,
      @required this.card,
      // ignore: non_constant_identifier_names
      @required this.home_fault,
      // ignore: non_constant_identifier_names
      @required this.away_fault,
      @required this.time,
      @required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffeeeeee).withOpacity(0.4),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      margin: EdgeInsets.only(bottom: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                Image(
                  image: NetworkImage('$logoTeam'),
                  width: 30.0,
                  height: 30.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: '$away_fault$home_fault',
                      style: kStyleScoreTime.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: kColorPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CardWidget(
              colour: card.toString() == "yellow card"
                  ? Colors.yellow
                  : Colors.redAccent),
          //  Text('$info'),
          SizedBox(
            width: 10.0,
          ),
          Text(
            '$time min',
            style: kStyleScoreTime,
          ),
        ],
      ),
    );
  }
}

class CardGoals extends StatelessWidget {
  final List<ListGoals> mList;
  CardGoals({@required this.mList});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shadowColor: Colors.black54.withOpacity(0.3),
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SvgPicture.asset(
                  'images/icon_goal.svg',
                  width: 20.0,
                  height: 20.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'Match goals',
                  style: kStyleChoose_2,
                ),
              ],
            ),
          ),
          Column(
            children: mList,
          ),
        ],
      ),
    );
  }
}

class ListGoals extends StatelessWidget {
  final logoTeam;
  // ignore: non_constant_identifier_names
  final player_home, player_away;
  final score;
  final time;

  ListGoals({
    @required this.logoTeam,
    // ignore: non_constant_identifier_names
    @required this.player_home,
    // ignore: non_constant_identifier_names
    @required this.player_away,
    @required this.score,
    @required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffeeeeee).withOpacity(0.4),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      margin: EdgeInsets.only(bottom: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                Image(
                  image: NetworkImage('$logoTeam'),
                  width: 30.0,
                  height: 30.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: '$player_home$player_away',
                      style: kStyleScoreTime.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: kColorPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Text(
            '$score',
            style: kStyleScoreTime.copyWith(
                fontWeight: FontWeight.w500, fontSize: 17.0),
          )),
          Text(
            '$time min',
            style: kStyleScoreTime,
          ),
        ],
      ),
    );
  }
}
