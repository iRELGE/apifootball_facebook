import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kooramd/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class TileButton extends StatelessWidget {
  final label;
  final IconData icon;
  final Function onPress;

  TileButton(
      {@required this.label, @required this.icon, @required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        child: InkWell(
          onTap: onPress,
          child: Center(
            child: ListTile(
              title: Text(
                '$label',
                style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w600,
                    color: kColorPrimary,
                    fontSize: 16.0,
                    height: 2.0),
              ),
              leading: Icon(
                icon,
                color: kColorPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardFollowInstagram extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await launch(kLinkInstagram);
      },
      child: Container(
        // height: 75.0,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.deepOrangeAccent,
          Colors.pinkAccent,
        ], end: Alignment.topCenter, begin: Alignment.bottomCenter)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.instagram,
              color: Colors.white,
              size: 40.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textBaseline: TextBaseline.alphabetic,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Follow us on Instagram',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  'Follow us on Instagram\nas we share the daily routine of our team\nand the following features that\nwe are working on',
                  maxLines: 3,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            Container(
              width: 72.0,
              height: 27.0,
              decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  border: Border.all(color: Colors.white, width: 1.5)),
              child: Center(
                child: Text(
                  'Follow',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    fontSize: 13.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
