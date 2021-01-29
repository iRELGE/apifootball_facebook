import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:kooramd/constants.dart';
import 'package:kooramd/screens/lives_screen.dart';
import 'package:kooramd/models/api/data_api.dart';
import 'package:kooramd/models/leages_brain.dart';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:kooramd/widgets/main_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kooramd/widgets/widgets_facebook.dart' as WidgetesAdmob;

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Firestore _firebase = Firestore.instance;
  static LeagesBrain leagesBrain = LeagesBrain();
  ScrollController _controller = ScrollController();

  bool onScroll = true;
  bool mProgress = false;
  bool isApiWorks = false;
  bool isUploading = true;

  //Change Infu Toolbare par defaute set Luge Espain
  // ignore: non_constant_identifier_names
  var leages_id = '468';
  var imgToolbare;
  var titleToolbare;

  void changeToolbare({var newImage, var newTitle, var newIdLuege}) {
    setState(() {
      newImage == null
          ? imgToolbare = leagesBrain.listLueges[1].image
          : imgToolbare = newImage;
      newTitle == null
          ? titleToolbare = leagesBrain.listLueges[1].title
          : titleToolbare = newTitle;
      newIdLuege == null ? leages_id = '468' : leages_id = newIdLuege;

      getApiDataLeagues();
    });
  }

  //Chnage Height toolbar
  double heightToolbar = kHeightNumToolbar;
  void showAndHideToolbar() {
    setState(() {
      heightToolbar == kHeightNumToolbar
          ? heightToolbar = 0.0
          : heightToolbar = kHeightNumToolbar;
    });
  }

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
      idLuega: leages_id,
    );

    try {
      for (var data in leagueData) {
        setState(() {
          mProgress = false; //show progress while getting data
          isApiWorks = true;
        });
        setState(() {
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
        });
        saveMatchesToDatabase(mMapMatches,
            lugeName: titleToolbare, date: dateToGetMatches);
      }
    } catch (e) {
      setState(() {
        isUploading = false;
        mProgress = true;
        isApiWorks = false;
      });
      print('Error: $e');
      print('Error: ${leagueData['message']}');
    }
  }

  Future<void> saveMatchesToDatabase(Map<String, dynamic> mMapMatches,
      {var lugeName, var date}) async {
    final uploadData =
        _firebase.collection('Lueges').document('laliga_$leages_id');
    final uploadData2 =
        _firebase.collection('Lueges').document('laliga_$leages_id');

    await uploadData.setData({
      'title': '$lugeName',
      'image': '$imgToolbare',
      'id_luege': '$leages_id',
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
      showToast(context, message: onError, color: kColorPrimaryDark);
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
      setState(() {
        isUploading = false;
      });
    } else {
      print("api work's fine ^_^");
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _firebase
          .collection('Lueges')
          .document('laliga_$leages_id')
          .collection('Date')
          .document(dateToGetMatches)
          .collection('Matches')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return PageNoData();
        }
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
                    uid_luege: 'laliga_$leages_id',
                    match_id_document: mData.documentID,
                    id_match: mData['match_id'],
                    logoLueges: imgToolbare,
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
      },
    );
  }

  @override
  void initState() {
    getApiDataLeagues();

    _controller.addListener(_controlerListView);
    imgToolbare = leagesBrain.listLueges[2].image; //default espain
    titleToolbare = leagesBrain.listLueges[2].title; //default espain
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 80.0,
                  width: mSize.width,
                  child: Material(
                    color: kColorPrimary,
                    elevation: heightToolbar == kHeightNumToolbar ? 0.0 : 2.0,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image(
                                image: NetworkImage(imgToolbare),
                                width: 50.0,
                                height: 50.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                '$titleToolbare',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Tajawal',
                                  fontSize: 20.0,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              heightToolbar == kHeightNumToolbar
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              showAndHideToolbar();
                            },
                            color: kColorPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: mSize.width,
                  height: heightToolbar,
                  padding: EdgeInsets.all(8.0),
                  color: kColorPrimary,
                  child: AnimationLimiter(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: leagesBrain.listLueges.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: Duration(seconds: 1),
                            child: SlideAnimation(
                              horizontalOffset:
                                  MediaQuery.of(context).size.width,
                              child: SlideAnimation(
                                child: ChipsLuegesList(
                                  image: leagesBrain.listLueges[index].image,
                                  label: leagesBrain.listLueges[index].title,
                                  id_leaga:
                                      leagesBrain.listLueges[index].id_leage,
                                  onPress: () async {
                                    await WidgetesAdmob
                                        .showInterstitialFacebook();
                                    if (leagesBrain.listLueges[index].id_leage
                                            .toString() ==
                                        "0") {
                                      Navigator.pushNamed(
                                          context, '/countries_screen');
                                    } else {
                                      showAndHideToolbar();
                                      changeToolbare(
                                        newImage:
                                            leagesBrain.listLueges[index].image,
                                        newTitle:
                                            leagesBrain.listLueges[index].title,
                                        newIdLuege: leagesBrain
                                            .listLueges[index].id_leage,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Container(
                  color: kColorPrimaryDark,
                  child: AbsorbPointer(
                    absorbing: isUploading,
                    child: CalendarStrip(
                      iconColor: Colors.white,
                      containerHeight: 58.0,
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
                !mProgress
                    ? LinearProgressIndicator(
                        backgroundColor: Colors.white,
                      )
                    : SizedBox(),
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

class PageNoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Matches for this day.',
            style: kStyleScore.copyWith(fontFamily: 'Tajawal'),
          ),
          SizedBox(
            height: 10.0,
          ),
          WidgetesAdmob.showNativeFacebook(),
        ],
      ),
    );
  }
}
