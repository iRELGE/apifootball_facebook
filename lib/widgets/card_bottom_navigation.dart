import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kooramd/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class BottomNavigation extends StatelessWidget {
  final Function cupWorld;
  final Function live;
  final Function home;
  final Function news;
  final Function more;

  BottomNavigation({this.cupWorld, this.live, this.home, this.news, this.more});

  @override
  Widget build(BuildContext context) {
    final mSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Positioned(
                top: 15.0,
                left: 5.0,
                right: 5.0,
                bottom: 2.0,
                child: Container(
                  height: 60.0,
                  child: LiquidLinearProgressIndicator(
                    value: 1.0, // Defaults to 0.5.
                    valueColor: AlwaysStoppedAnimation(kColorPrimaryDark),
                    backgroundColor: Colors.white,
                    borderColor: kColorPrimaryDark,
                    borderWidth: 0.1,
                    borderRadius: 30.0,
                    direction: Axis.vertical,
                  ),
                ),
              ),
              Container(
                width: mSize.width,
                height: 70.0,
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 13.0),
                      child: GestureDetector(
                        onTap: cupWorld,
                        child: SvgPicture.asset(
                          'images/notification.svg',
                          height: 35.0,
                          width: 35.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: GestureDetector(
                        onTap: live,
                        child: SvgPicture.asset(
                          'images/live.svg',
                          height: 35.0,
                          width: 35.0,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: home,
                      child: SvgPicture.asset(
                        'images/soccer.svg',
                        height: 70.0,
                        width: 70.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: GestureDetector(
                        onTap: news,
                        child: SvgPicture.asset(
                          'images/news.svg',
                          height: 35.0,
                          width: 35.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: GestureDetector(
                        onTap: more,
                        child: SvgPicture.asset(
                          'images/more.svg',
                          height: 25.0,
                          width: 25.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BottomNavigationFontAwesom extends StatelessWidget {
  final Function cupWorld;
  final Function live;
  final Function home;
  final Function news;
  final Function more;

  BottomNavigationFontAwesom(
      {this.cupWorld, this.live, this.home, this.news, this.more});

  @override
  Widget build(BuildContext context) {
    final mSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Positioned(
                top: 15.0,
                left: 5.0,
                right: 5.0,
                bottom: 2.0,
                child: Container(
                  height: 60.0,
                  child: LiquidLinearProgressIndicator(
                    value: 1.0, // Defaults to 0.5.
                    valueColor: AlwaysStoppedAnimation(kColorPrimaryDark),
                    backgroundColor: Colors.white,
                    borderColor: kColorPrimaryDark,
                    borderWidth: 0.1,
                    borderRadius: 30.0,
                    direction: Axis.vertical,
                  ),
                ),
              ),
              Container(
                width: mSize.width,
                height: 70.0,
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 13.0),
                      child: IconButton(
                        onPressed: cupWorld,
                        icon: Icon(
                          FontAwesomeIcons.bell,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 13.0),
                      child: IconButton(
                        onPressed: live,
                        icon: Icon(
                          FontAwesomeIcons.comments,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: home,
                      child: SvgPicture.asset(
                        'images/soccer.svg',
                        height: 70.0,
                        width: 70.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 13.0),
                      child: IconButton(
                        onPressed: news,
                        icon: Icon(
                          FontAwesomeIcons.newspaper,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 13.0),
                      child: IconButton(
                        onPressed: more,
                        icon: Icon(
                          FontAwesomeIcons.ellipsisH,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
