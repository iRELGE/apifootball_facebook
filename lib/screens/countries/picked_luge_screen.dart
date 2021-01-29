import 'dart:async';

import 'package:calendar_strip/calendar_strip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:intl/intl.dart';
import 'package:kooramd/constants.dart';
import 'package:kooramd/screens/lives_screen.dart';
import 'package:kooramd/screens/welcome_screen.dart';
import 'package:kooramd/models/api/data_api.dart';
import 'package:kooramd/widgets/main_widgets.dart';
import 'package:kooramd/widgets/toolbares_widgets.dart';
import 'package:kooramd/widgets/widgets_facebook.dart' as WidgetesAdmob;

class PickedLugeScreen extends StatefulWidget {
  final idLuge;
  final nameLuge;
  final logoLuge;

  PickedLugeScreen(
      {@required this.idLuge,
      @required this.nameLuge,
      @required this.logoLuge});

  @override
  _PickedLugeScreenState createState() => _PickedLugeScreenState();
}

class _PickedLugeScreenState extends State<PickedLugeScreen> {
  Firestore _firebase = Firestore.instance;
  ScrollController _controller = ScrollController();

  bool onScroll = true;
  bool mProgress = false;
  bool isApiWorks = false;
  bool isUploading;

  var newDate = dateDays; // as defaulte todays date
  void getDateChanged(var newDateSelected) {
    setState(() {
      mProgress = false;
      newDate = DateFormat.d().format(newDateSelected);
      var newNumDay = DateFormat.EEEE().format(newDateSelected);
      var newYear = DateFormat.y().format(newDateSelected);
      var newMonth = DateFormat.M().format(newDateSelected);
      newDateSelected == null
          ? finDate = '$dateNumDays - $dateDays - $dateMonth - $dateYears'
          : finDate = '$newNumDay - $newDate - $newMonth - $newYear';

      newDateSelected == null
          ? dateToGetMatches = '$dateYears-$dateMonth-$dateDays'
          : dateToGetMatches = '$newYear-$newMonth-$newDate';

      getApiDataLeagues();
    });
  }

  DataApi dataApi = DataApi();
  Map<String, dynamic> mMapMatches = {};

  Future<dynamic> getApiDataLeagues() async {
    final leagueData = await dataApi.getDataLeaguesApi(
      dateFrom: dateToGetMatches,
      dateTo: dateToGetMatches,
      idLuega: widget.idLuge,
    );

    try {
      for (var data in leagueData) {
        setState(() {
          mProgress = false; //show progress while getting data
          isApiWorks = true;
          mMapMatches.addAll({
            'match_id': data['match_id'],
            'country_id': data['country_id'],
            'league_id': data['league_id'],
            'league_name': data['league_name'],
            'match_date': data['match_date'],
            'match_status': data['match_status'],
            'match_time': data['match_time'],
            'match_live': data['match_live'],
            'match_hometeam_name': data['match_hometeam_name'],
            'match_hometeam_score': data['match_hometeam_score'],
            'match_awayteam_name': data['match_awayteam_name'],
            'match_awayteam_score': data['match_awayteam_score'],
            'team_home_badge': data['team_home_badge'],
            'team_away_badge': data['team_away_badge'],
          });
          saveMatchesToDatabase(mMapMatches,
              lugeName: data['league_name'], date: dateToGetMatches);
        });
        //  print(data['league_name']);
      }
    } catch (e) {
      print('Error: $e');
      print('${leagueData['message']}');
      setState(() {
        isUploading = false;
        mProgress = true;
        isApiWorks = false;
      });
    }
  }

  Future<void> saveMatchesToDatabase(Map<String, dynamic> mMapMatches,
      {var lugeName, @required var date}) async {
    final uploadData =
        _firebase.collection('Lueges').document('laliga_${widget.idLuge}');
    final uploadData2 =
        _firebase.collection('Lueges').document('laliga_${widget.idLuge}');

    await uploadData.setData({
      'title': '$lugeName',
      'image': '${widget.logoLuge}',
      'id_luege': '${widget.idLuge}',
    });

    await uploadData.collection('Date').document(date).setData({
      'date': '$date',
    });

    await uploadData2
        .collection('Date')
        .document(date)
        .collection('Matches')
        .document(
            '${mMapMatches['match_hometeam_name']}-VS-${mMapMatches['match_awayteam_name']}')
        .setData(mMapMatches)
        .then(
            (value) => {
                  setState(() {
                    mProgress = true;
                    isUploading = false;
                  }),
                }, onError: (onError) {
      print('Error Save Data: $onError');
      setState(() {
        mProgress = true;
        isUploading = false;
      });
    });
  }

  void _controlerListView() {
    setState(() {
      onScroll =
          _controller.position.userScrollDirection == ScrollDirection.forward;
    });
  }

  Widget checkIfDataNotNull() {
    if (isApiWorks == false) {
      print("Something wrong in api!!");
    } else {
      print("api work's fine ^_^");
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _firebase
          .collection('Lueges')
          .document('laliga_${widget.idLuge}')
          .collection('Date')
          .document(dateToGetMatches)
          .collection('Matches')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final macthes = snapshot.data.documents;
          List<Widget> mListMatches = [];

          if (macthes.length == 0) {
            return PageNoData();
          }

          mListMatches.add(
            WidgetesAdmob.showNativeFacebookBanner(),
          );
          for (var mData in macthes) {
            mListMatches.add(
              ListMatches(
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LivesScreen(
                      //Pass data to page Content
                      dateMatche: dateToGetMatches,
                      uid_luege: 'laliga_${widget.idLuge}',
                      match_id_document: mData.documentID,
                      id_match: mData['match_id'],
                      logoLueges: widget.logoLuge,
                      homeLogo: mData['team_home_badge'],
                      awayLogo: mData['team_away_badge'],
                      nameTeamHome: mData['match_hometeam_name'],
                      nameTeamAway: mData['match_awayteam_name'],
                    );
                  }));
                },
                //pass data to listview bottom
                awayName: mData['match_awayteam_name'],
                homeName: mData['match_hometeam_name'],
                awayScore: mData['match_awayteam_score'],
                homeScore: mData['match_hometeam_score'],
                league_name: mData['league_name'],
                logoAway: mData['team_away_badge'],
                logoHome: mData['team_home_badge'],
                match_date: mData['match_date'],
                match_status: mData['match_status'],
              ),
            );
          }

          return Flexible(
            child: ListView(
              scrollDirection: Axis.vertical,
              controller: _controller,
              children: mListMatches,
            ),
          );
        } else {
          return PageNoData();
        }
      },
    );
  }

  @override
  void initState() {
    getApiDataLeagues();

    _controller.addListener(_controlerListView);
    isUploading = true;
    super.initState();
  }

  @override
  void dispose() {
    setState(() {
      isUploading = true;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                ToolbarCountries(
                    luegesName: widget.nameLuge,
                    logoLueges: widget.logoLuge,
                    logoAssest: 'null'),
                Container(
                  color: kColorPrimaryDark,
                  child: AbsorbPointer(
                    absorbing: isUploading,
                    child: CalendarStrip(
                      iconColor: Colors.white,
                      containerHeight: 62.0,
                      dateTileBuilder: dateTileBuilder,
                      monthNameWidget: monthNameWidget,
                      addSwipeGesture: true,
                      onDateSelected: (dayName) {
                        setState(() {
                          isUploading = true;
                        });
                        getDateChanged(dayName);
                      },
                    ),
                  ),
                ),
                mProgress == false
                    ? LinearProgressIndicator(
                        backgroundColor: Colors.white,
                      )
                    : Container(),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: Text(
                      'Day selected: $finDate',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.0,
                        color: kColorPrimary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ),
                checkIfDataNotNull(),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: fabCircularMenu(context),
    );
  }
}
