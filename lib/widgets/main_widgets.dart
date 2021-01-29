import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kooramd/constants.dart';

//Widget showBottomNavigation({
//  @required bool onScroll,
//  @required BuildContext context,
//}) {
//  if (onScroll) {
//    return BottomNavigationFontAwesom(
//      home: () async {
//        Navigator.pushReplacementNamed(context, '/welcome_screen');
//      },
//      news: () {
//        Navigator.pushNamed(context, '/news_screen');
//      },
//      more: () {
//        Navigator.pushNamed(context, '/more_screen');
//      },
//      live: () {
//        //do
//      },
//    );
//  } else {
//    return Container();
//  }
//}

FabCircularMenu fabCircularMenu(BuildContext context) {
  return FabCircularMenu(
    children: <Widget>[
      IconButton(
        icon: Icon(
          FontAwesomeIcons.ellipsisH,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/more_screen');
        },
      ),
      IconButton(
        icon: Icon(
          FontAwesomeIcons.share,
          color: Colors.white,
        ),
        onPressed: () async {
          await FlutterShareMe().shareToSystem(msg: kLinkRateApp);
        },
      ),
      IconButton(
        icon: Icon(
          FontAwesomeIcons.newspaper,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/news_screen');
        },
      ),
      IconButton(
        icon: Icon(
          FontAwesomeIcons.home,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/welcome_screen');
        },
      ),
    ],
  );
}

/* CalendarStrip */
dateTileBuilder(
    date, selectedDate, rowIndex, dayName, isDateMarked, isDateOutOfRange) {
  bool isSelectedDate = date.compareTo(selectedDate) == 0;
  Color fontColor = isDateOutOfRange ? Colors.white : Colors.white;

  TextStyle selectedStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w800,
      color: Colors.white,
      fontFamily: 'Tajawal');
  TextStyle dayNameStyle = TextStyle(fontSize: 14.5, color: fontColor);
  List<Widget> _children = [
    Text('$dayName', style: !isSelectedDate ? dayNameStyle : selectedStyle),
    SizedBox(
      height: 5.0,
    ),
    Text(date.day.toString(),
        style: !isSelectedDate ? dayNameStyle : selectedStyle),
  ];
  return AnimatedContainer(
    duration: Duration(milliseconds: 150),
    alignment: Alignment.center,
    margin: EdgeInsets.all(0.0),
    padding: EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 5),
    decoration: BoxDecoration(
      color: !isSelectedDate ? Colors.transparent : kColorPrimary,
      borderRadius: BorderRadius.all(Radius.circular(0)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: _children,
    ),
  );
}

monthNameWidget(monthName) {
  return Container(
//    child: Text(
//      '${getDay(monthName)}',
//      style: TextStyle(
//        fontSize: 17,
//        fontWeight: FontWeight.w600,
//        color: Colors.white,
//        fontStyle: FontStyle.italic,
//      ),
//    ),
    padding: EdgeInsets.only(top: 0),
  );
}
/* End CalendarStrip */

String getDay(var monthName) {
  return monthName;
}

class ListMatches extends StatelessWidget {
  final Function onPress;
  final logoHome;
  final logoAway;
  // ignore: non_constant_identifier_names
  final league_name;
  // ignore: non_constant_identifier_names
  final match_date;
  // ignore: non_constant_identifier_names
  final match_status;
  final homeName, awayName;
  final homeScore, awayScore;

  ListMatches({
    this.onPress,
    this.logoHome,
    this.logoAway,
    // ignore: non_constant_identifier_names
    this.league_name,
    // ignore: non_constant_identifier_names
    this.match_date,
    // ignore: non_constant_identifier_names
    this.match_status,
    this.homeName,
    this.awayName,
    this.homeScore,
    this.awayScore,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      onLongPress: () async {
        await FlutterShareMe().shareToSystem(
          msg: '$awayName $awayScore _vs_ $homeScore $homeName \n\n' +
              kLinkRateApp,
        );
      },
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 6.0),
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width,
            // height: 100.0,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image(
                      image: NetworkImage(logoHome),
                      width: kHeightLogoTeam,
                      height: kHeightLogoTeam,
                    ),
                    TextTeams(homeName),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      '$league_name',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                          color: kColorBlack1),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '$homeScore',
                          style: kStyleScore,
                        ),
                        SizedBox(
                          width: 25.0,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'VS',
                              style: kStyleScore,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              '$match_status',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 25.0,
                        ),
                        Text(
                          '$awayScore',
                          style: kStyleScore,
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
                      width: kHeightLogoTeam,
                      height: kHeightLogoTeam,
                    ),
                    TextTeams(awayName),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2.0,
            child: Divider(
              color: Color(0xFFEEEEEE),
            ),
          ),
        ],
      ),
    );
  }
}

class TextTeams extends StatelessWidget {
  final teamName;
  TextTeams(this.teamName);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 85.0,
      child: Center(
          child: Text(
        '$teamName',
        textAlign: TextAlign.center,
        maxLines: 2,
        style: kStyleNameTeams,
      )),
    );
  }
//  RichText(
//  // overflow: TextOverflow.ellipsis,
//  text: TextSpan(
//  text: '$teamName',
//  style: kStyleNameTeams,
//  ),
//  ),
}

class ChipsLuegesList extends StatelessWidget {
  final String label;
  final image;
  // ignore: non_constant_identifier_names
  final id_leaga;
  final Function onPress;

  ChipsLuegesList(
      // ignore: non_constant_identifier_names
      {this.label,
      this.image,
      // ignore: non_constant_identifier_names
      this.id_leaga,
      @required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
        decoration: BoxDecoration(
          color: kColorPrimaryDark,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image(
                image: NetworkImage(image),
                width: 25.0,
                height: 25.0,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DaysCalendar extends StatelessWidget {
  final String label;
  final date;
  final Function onPress;

  DaysCalendar(
      {@required this.label, @required this.date, @required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: <Widget>[
            Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
            CircleAvatar(
              maxRadius: 10.0,
              backgroundColor: Colors.green.withOpacity(0.8),
              child: Center(
                child: Text(
                  '$date',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
//            Text(
//              '$date',
//              style: TextStyle(color: Colors.white, fontSize: 13.0),
//            ),
          ],
        ),
      ),
    );
  }
}

class CardShareMatch extends StatelessWidget {
  final IconData icon;
  final Function onPress;
  CardShareMatch({@required this.icon, @required this.onPress});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPress,
      shape: CircleBorder(),
      elevation: 0.5,
      fillColor: Colors.white,
      child: SizedBox(
        width: 56,
        height: 56,
        child: Icon(
          icon,
          color: kColorBlack1,
          size: 25.0,
        ),
      ),
    );
  }
}
