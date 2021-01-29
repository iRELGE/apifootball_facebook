import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:time_ago_provider/time_ago_provider.dart';

// ignore: must_be_immutable
class CardVotesUsers extends StatelessWidget {
  double heightContainer = 55.0;
  double topContainer = 30.0;

  final logoHome, logoAway;
  final voteHome, voteAway;
  final userName;
  final date;
  final messageUser;
  final imageProfile;

  CardVotesUsers({
    this.logoHome,
    this.logoAway,
    this.voteHome,
    this.voteAway,
    this.userName,
    this.date,
    this.messageUser,
    this.imageProfile,
  });

  String getDate() {
    String timeAgo = TimeAgo.getTimeAgo(date);
    // print('$timeAgo');
    return '$timeAgo';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              right: 20.0,
              left: 35.0,
            ),
            margin: EdgeInsets.only(
              top: topContainer,
              left: 15.0,
              right: 5.0,
            ),
            height: heightContainer,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kColorPrimaryDark,
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, offset: Offset(1, 1), blurRadius: 5.0)
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '$userName',
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      style: kStyleTextVote.copyWith(
                          fontSize: 12.0, fontFamily: 'Tajawal'),
                    ),
                    //set visiblt gone
                    Offstage(
                      offstage: messageUser.toString() == "" ? true : false,
                      child: Padding(
                        padding: EdgeInsets.only(top: 25.0),
                        child: Text(
                          '$messageUser',
                          textAlign: TextAlign.center,
                          style: kStyleTextVote.copyWith(
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.w400,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '${getDate()}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned.fill(
              top: topContainer,
              child: Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  backgroundColor: kColorPrimaryDark,
                  radius: 23.0,
                  child: CircleAvatar(
                    backgroundColor: kColorPrimaryDark,
                    maxRadius: 21.0,
                    backgroundImage: imageProfile == ''
                        ? AssetImage('images/avatar.png')
                        : NetworkImage('$imageProfile'),
                  ),
                ),
              )),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: kColorPrimary,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image(
                    image: NetworkImage('$logoHome'),
                    width: 25.0,
                    height: 25.0,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '$voteHome',
                    style: kStyleTextVote,
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: Text(
                      'VS',
                      style: kStyleTextVote,
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    '$voteAway',
                    style: kStyleTextVote,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Image(
                    image: NetworkImage('$logoAway'),
                    width: 25.0,
                    height: 25.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
