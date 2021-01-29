import 'package:flutter/material.dart';
import 'package:kooramd/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kooramd/widgets/stadium_widget.dart';
import 'card_player.dart';

class HeaderTeams extends StatelessWidget {
  final logoHome;
  final logoAway;
  // ignore: non_constant_identifier_names
  final league_name;
  // ignore: non_constant_identifier_names
  final match_time;
  // ignore: non_constant_identifier_names
  final match_status;
  final homeName, awayName;
  final homeScore, awayScore;
  final double heighLogo;

  HeaderTeams({
    this.logoHome,
    this.logoAway,
    // ignore: non_constant_identifier_names
    this.league_name,
    // ignore: non_constant_identifier_names
    this.match_time,
    // ignore: non_constant_identifier_names
    this.match_status,
    this.homeName,
    this.awayName,
    this.homeScore,
    this.awayScore,
    this.heighLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 6.0),
          padding: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width,
          height: 130.0,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Image(
                    image: NetworkImage(logoHome),
                    width: heighLogo * 55.0,
                    height: heighLogo * 55.0,
                  ),
                  SizedBox(
                    width: 65.0,
                    child: Text(
                      '$homeName',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: kStyleNameTeams.copyWith(
                          color: Colors.white,
                          fontFamily: 'Tajawal',
                          fontSize: heighLogo * 15.0),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    '$league_name',
                    style: TextStyle(
                        fontSize: heighLogo * 22.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 7.0,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '$homeScore',
                        style: kStyleScore.copyWith(
                            color: Colors.white,
                            fontFamily: 'Tajawal',
                            fontSize: heighLogo * 18.0),
                      ),
                      SizedBox(
                        width: 25.0,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'VS',
                            style: kStyleScore.copyWith(
                                color: Colors.white,
                                fontFamily: 'Tajawal',
                                fontSize: heighLogo * 18.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                '$match_time',
                                style: TextStyle(
                                    fontSize: heighLogo * 12.0,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Icon(
                                Icons.timelapse,
                                color: Colors.white,
                                size: heighLogo * 12.0,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 7.0,
                          ),
                          Text(
                            '$match_status',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Tajawal',
                                fontSize: heighLogo * 18.0),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 25.0,
                      ),
                      Text(
                        '$awayScore',
                        style: kStyleScore.copyWith(
                            color: Colors.white,
                            fontFamily: 'Tajawal',
                            fontSize: heighLogo * 18.0),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Image(
                    image: NetworkImage(logoAway),
                    width: heighLogo * 55.0,
                    height: heighLogo * 55.0,
                  ),
                  SizedBox(
                    width: 65.0,
                    child: Text(
                      '$awayName',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: kStyleNameTeams.copyWith(
                          color: Colors.white,
                          fontFamily: 'Tajawal',
                          fontSize: heighLogo * 15.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CardSubstitutions extends StatelessWidget {
  final List<CardPlayer> mList;
  CardSubstitutions({@required this.mList});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shadowColor: Colors.black54.withOpacity(0.3),
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SvgPicture.asset(
                  'images/icon_chair.svg',
                  width: 20.0,
                  height: 20.0,
                  color: kColorPrimaryDark,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'Substitutes',
                  style: kStyleChoose_2,
                ),
              ],
            ),
            Wrap(
              spacing: 10.0,
              direction: Axis.horizontal,
              children: mList,
            ),
          ],
        ),
      ),
    );
  }
}

class CardMissingPlayer extends StatelessWidget {
  final List<CardPlayer> mList;
  CardMissingPlayer({@required this.mList});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shadowColor: Colors.black54.withOpacity(0.3),
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.phone_missed,
                  color: kColorPrimaryDark,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'Missing players',
                  style: kStyleChoose_2,
                ),
              ],
            ),
            Wrap(
              spacing: 10.0,
              direction: Axis.horizontal,
              children: mList,
            ),
          ],
        ),
      ),
    );
  }
}

class CardStadium extends StatelessWidget {
  final Map<String, dynamic> mMap;
  CardStadium({@required this.mMap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shadowColor: Colors.black54.withOpacity(0.3),
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SvgPicture.asset(
                  'images/icon_players.svg',
                  width: 15.0,
                  height: 15.0,
                  color: kColorPrimaryDark,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'Lineup',
                  style: kStyleChoose_2,
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                StadiumWidget(
                  //set the number t-shirt to positions
                  playe_1: mMap['number1'] ?? '',
                  playe_2: mMap['number2'] ?? '',
                  playe_3: mMap['number3'] ?? '',
                  playe_4: mMap['number4'] ?? '',
                  playe_5: mMap['number5'] ?? '',
                  playe_6: mMap['number6'] ?? '',
                  playe_7: mMap['number7'] ?? '',
                  playe_8: mMap['number8'] ?? '',
                  playe_9: mMap['number9'] ?? '',
                  playe_10: mMap['number10'] ?? '',
                  playe_11: mMap['number11'] ?? '',
                ),
                SizedBox(
                  height: 10.0,
                ),
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 10.0,
                  children: <Widget>[
                    CardPlayer(
                        numberPlayer: mMap['number3'] ?? '',
                        namePlayer: mMap['player3'] ?? ''),
                    CardPlayer(
                        numberPlayer: mMap['number4'] ?? '',
                        namePlayer: mMap['player4'] ?? ''),
                    CardPlayer(
                        numberPlayer: mMap['number5'] ?? '',
                        namePlayer: mMap['player5'] ?? ''),
                    CardPlayer(
                        numberPlayer: mMap['number6'] ?? '',
                        namePlayer: mMap['player6'] ?? ''),
                    CardPlayer(
                        numberPlayer: mMap['number7'] ?? '',
                        namePlayer: mMap['player7'] ?? ''),
                    CardPlayer(
                        numberPlayer: mMap['number8'] ?? '',
                        namePlayer: mMap['player8'] ?? ''),
                    CardPlayer(
                        numberPlayer: mMap['number9'] ?? '',
                        namePlayer: mMap['player9'] ?? ''),
                    CardPlayer(
                        numberPlayer: mMap['number10'] ?? '',
                        namePlayer: mMap['player10'] ?? ''),
                    CardPlayer(
                        numberPlayer: mMap['number11'] ?? '',
                        namePlayer: mMap['player11'] ?? ''),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardBoss extends StatelessWidget {
  final nameBoss;
  CardBoss({@required this.nameBoss});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shadowColor: Colors.black54.withOpacity(0.3),
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.person,
              color: kColorPrimaryDark,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              'Coach',
              style: kStyleChoose_2,
            ),
            Expanded(child: Center(child: Text('$nameBoss'))),
            SizedBox(
              width: 5.0,
            ),
          ],
        ),
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final Function onPress;
  final teamName;
  final bool choose;

  TabButton({this.onPress, this.teamName, this.choose});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          height: 35.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            border: choose == true
                ? null
                : Border.all(color: kColorPrimaryDark, width: 1.5),
            color: choose == true ? kColorPrimaryDark : Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: '$teamName',
                    style: choose == true
                        ? kStyleChoose_1.copyWith(fontSize: 15.0)
                        : kStyleChoose_2.copyWith(
                            fontSize: 15.0, color: kColorPrimaryDark),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
