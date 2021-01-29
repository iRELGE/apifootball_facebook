import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kooramd/screens/fragments/plains/away_plains.dart';
import 'package:kooramd/screens/fragments/plains/home_plains.dart';
import 'package:kooramd/widgets/lives_widgets.dart';

class PlanScreen extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final uid_match;
  // ignore: non_constant_identifier_names
  final date_match;
  final nameTeamAway;
  final nameTeamHome;

  PlanScreen(
      // ignore: non_constant_identifier_names
      {@required this.uid_match,
      // ignore: non_constant_identifier_names
      @required this.date_match,
      @required this.nameTeamAway,
      @required this.nameTeamHome});

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  bool onCheckButton_1 = true;
  bool onCheckButton_2 = false;

  var theTeam = 'Home'; //default
  Widget setPlainWidgets() {
    return theTeam == 'Home'
        ? HomePlains(
            date_match: widget.date_match,
            uid_match: widget.uid_match,
          )
        : AwayPlains(
            date_match: widget.date_match,
            uid_match: widget.uid_match,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Material(
            elevation: 4.0,
            shadowColor: Colors.black54.withOpacity(0.3),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: <Widget>[
                  TabButton(
                    onPress: () {
                      setState(() {
                        onCheckButton_1 == true
                            ? onCheckButton_1 = false
                            : onCheckButton_1 = true;
                        onCheckButton_1 == true
                            ? onCheckButton_2 = false
                            : onCheckButton_2 = true;

                        //Change
                        theTeam = 'Home';
                      });
                    },
                    choose: onCheckButton_1,
                    teamName: '${widget.nameTeamHome}',
                  ),
                  TabButton(
                    onPress: () {
                      setState(() {
                        onCheckButton_2 == true
                            ? onCheckButton_2 = false
                            : onCheckButton_2 = true;
                        onCheckButton_2 == true
                            ? onCheckButton_1 = false
                            : onCheckButton_2 = true;
                        // do if button checked
                        //Change
                        theTeam = 'Away';
                      });
                    },
                    choose: onCheckButton_2,
                    teamName: '${widget.nameTeamAway}',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          setPlainWidgets(),
        ],
      ),
    );
  }
}
