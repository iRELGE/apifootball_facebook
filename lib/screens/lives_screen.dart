import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kooramd/screens/fragments/infu_screen.dart';
import 'package:kooramd/screens/fragments/plan_screen.dart';
import 'package:kooramd/screens/fragments/static_screen.dart';
import 'package:kooramd/screens/fragments/highlight_screen.dart';
import 'package:kooramd/screens/fragments/vote_screen.dart';
import 'package:kooramd/screens/more/stream_live_screen.dart';
import 'package:kooramd/widgets/lives_widgets.dart';
import 'package:kooramd/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kooramd/widgets/toolbares_widgets.dart';

class LivesScreen extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final match_id_document;
  // ignore: non_constant_identifier_names
  final uid_luege;
  // ignore: non_constant_identifier_names
  final id_match;
  final dateMatche;
  final logoLueges;
  final homeLogo;
  final awayLogo;
  final nameTeamAway;
  final nameTeamHome;

  LivesScreen({
    // ignore: non_constant_identifier_names
    @required this.uid_luege,
    // ignore: non_constant_identifier_names
    @required this.match_id_document,
    // ignore: non_constant_identifier_names
    @required this.id_match,
    @required this.dateMatche,
    @required this.logoLueges,
    @required this.homeLogo,
    @required this.awayLogo,
    @required this.nameTeamAway,
    @required this.nameTeamHome,
  });

  @override
  _LivesScreenState createState() => _LivesScreenState();
}

class _LivesScreenState extends State<LivesScreen>
    with SingleTickerProviderStateMixin {
  final _firestore = Firestore.instance;
  Animation animation;
  AnimationController controller;
  bool _liveButton = false;

  var luegesName = '';
  var homeName = '';
  var awayName = '';
  var statusMatch = '';
  var homeScore = '';
  var awayScore = '';
  // ignore: non_constant_identifier_names
  var match_time = '';

  void getDataMatcheFirebase() async {
    final matchData = _firestore
        .collection('Lueges')
        .document(widget.uid_luege)
        .collection('Date')
        .document(widget.dateMatche)
        .collection('Matches')
        .document(widget.match_id_document)
        .snapshots();

    matchData.listen((event) {
      setState(() {
        luegesName = event['league_name'];
        homeScore = event['match_hometeam_score'];
        awayScore = event['match_awayteam_score'];
        homeName = event['match_hometeam_name'];
        awayName = event['match_awayteam_name'];
        statusMatch = event['match_status'];
        match_time = event['match_time'];
      });
    });
  }

  void setAnimation() {
    controller =
        AnimationController(duration: Duration(milliseconds: 900), vsync: this);

    //start forward from 0 to 1 / reverse from: 1 to 0
    controller.forward();
    animation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutQuint);
    //listen to the controller
    animation.addListener(() {
      // print(animation.value);
      setState(() {});
    });
  }

  Widget _showLiveServer() {
    return AlertDialog(
      elevation: 2.0,
      backgroundColor: Colors.white,
      content: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('Lueges')
                  .document(widget.uid_luege)
                  .collection('Date')
                  .document(widget.dateMatche)
                  .collection('Matches')
                  .document(widget.match_id_document)
                  .collection('Lives')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final mServers = snapshot.data.documents;
                List<RawButtonServer> mListRawButtonServer = [];

                for (var server in mServers) {
                  mListRawButtonServer.add(RawButtonServer(
                    title: server.data['title'],
                    onPress: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StreamLiveScreen(
                                linkServer: server.data['link']),
                          ));
                    },
                  ));
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: mListRawButtonServer,
                );
              })),
    );
  }

  Future<dynamic> checkIfLiveOn() async {
    final checkLives = await _firestore
        .collection('Lueges')
        .document(widget.uid_luege)
        .collection('Date')
        .document(widget.dateMatche)
        .collection('Matches')
        .document(widget.match_id_document)
        .collection('Lives')
        .getDocuments();
    if (checkLives.documents.length == 0) {
      setState(() {
        _liveButton = false;
      });
    } else {
      setState(() {
        _liveButton = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getDataMatcheFirebase();
    setAnimation();
    checkIfLiveOn();
  }

  @override
  Widget build(BuildContext context) {
    final mSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ToolbareLives(
              logoLueges: widget.logoLueges,
              luegesName: luegesName,
            ),
            Container(
              width: mSize.width,
              height: mSize.height,
              margin: EdgeInsets.only(
                  top: 75.0, left: 10.0, right: 10.0, bottom: 0.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5.0),
                    width: mSize.width,
                    //   height: 175.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)),
                      color: kColorPrimaryDark,
                      image: DecorationImage(
                        image: AssetImage('images/img_tearen.png'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            kColorPrimaryDark.withOpacity(0.4),
                            BlendMode.dstATop),
                      ),
                    ),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        HeaderTeams(
                          match_status: '$statusMatch',
                          match_time: '$match_time',
                          logoHome: '${widget.homeLogo}',
                          logoAway: '${widget.awayLogo}',
                          league_name: '$luegesName',
                          homeName: '$homeName',
                          homeScore: '$homeScore',
                          awayScore: '$awayScore',
                          awayName: '$awayName',
                          heighLogo: animation.value,
                        ),
                        Visibility(
                          visible: _liveButton,
                          child: FlatButton(
                            color: Colors.white,
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return _showLiveServer();
                                },
                              );
                            },
                            child: Text(
                              'Watch',
                              style: kStyleNameTeams.copyWith(fontSize: 13.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: DefaultTabController(
                      length: 5,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: mSize.width,
                            color: kColorPrimary,
                            child: TabBar(
                              isScrollable: true,
                              indicatorColor: Colors.white,
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                              ),
                              tabs: [
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Tab(text: 'informations')),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Tab(text: 'Lineup')),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Tab(text: 'Match events')),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Tab(text: 'Vote')),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Tab(text: 'Highlights')),
                              ],
                            ),
                          ),
                          Flexible(
                            child: TabBarView(
                              children: [
                                InfuScreen(
                                  nameAway: widget.nameTeamAway,
                                  nameHome: widget.nameTeamHome,
                                ),
                                PlanScreen(
                                  date_match: widget.dateMatche,
                                  uid_match: widget.id_match,
                                  nameTeamAway: widget.nameTeamAway,
                                  nameTeamHome: widget.nameTeamHome,
                                ),
                                StaticScreen(
                                  date_match: widget.dateMatche,
                                  uid_match: widget.id_match,
                                ),
                                VoteScreen(
                                  document_id_match: widget.match_id_document,
                                  dateMatche: widget.dateMatche,
                                  uid_luege: widget.uid_luege,
                                  logoHome: '${widget.homeLogo}',
                                  logoAway: '${widget.awayLogo}',
                                ),
                                HighLightsScreen(
                                  codument_id_match: widget.match_id_document,
                                  dateMatche: widget.dateMatche,
                                  uid_luege: widget.uid_luege,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RawButtonServer extends StatelessWidget {
  final onPress;
  final title;
  RawButtonServer({@required this.onPress, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: onPress,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Container(
            width: 200.0,
            height: 45.0,
            decoration: BoxDecoration(
              color: kColorPrimaryDark,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              image: DecorationImage(
                  image: AssetImage('images/img_tearen.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      kColorPrimaryDark.withOpacity(0.3), BlendMode.dstATop)),
            ),
            child: Center(
                child: Text(
              '$title',
              style: TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
            )),
          ),
        ),
      ),
    );
  }
}
