import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants.dart';

class ToolbareNews extends StatelessWidget {
  final assetImage;
  final title;
  ToolbareNews({@required this.assetImage, @required this.title});

  @override
  Widget build(BuildContext context) {
    final mSize = MediaQuery.of(context).size;
    return Material(
      elevation: 2.0,
      color: kColorPrimary,
      child: Container(
        width: mSize.width,
        height: 75.0,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SvgPicture.asset(
                    'images/$assetImage',
                    width: 50.0,
                    height: 50.0,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '$title',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20.0,
                      fontFamily: 'Tajawal',
                      height: 2.0,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToolbareLives extends StatelessWidget {
  final luegesName;
  final logoLueges;
  ToolbareLives({@required this.luegesName, @required this.logoLueges});

  @override
  Widget build(BuildContext context) {
    final mSize = MediaQuery.of(context).size;
    return Container(
      width: mSize.width,
      height: 160.0,
      child: Material(
        color: kColorPrimary,
        child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image(
                      image: NetworkImage('$logoLueges'),
                      width: 50.0,
                      height: 50.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      '$luegesName',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22.0,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ToolbarCountries extends StatelessWidget {
  final luegesName;
  final logoLueges;
  final logoAssest;
  ToolbarCountries(
      {@required this.luegesName,
      @required this.logoLueges,
      @required this.logoAssest});

  Widget getImage() {
    if (logoAssest == null) {
      return SvgPicture.asset(
        'images/soccer.svg',
        width: 50.0,
        height: 50.0,
      );
    } else {
      if (logoLueges.toString() != "") {
        return Hero(
          tag: '$luegesName',
          child: Image(
            image: NetworkImage('$logoLueges'),
            width: 50.0,
            height: 50.0,
          ),
        );
      } else {
        return SvgPicture.asset(
          'images/soccer.svg',
          width: 50.0,
          height: 50.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mSize = MediaQuery.of(context).size;
    return Container(
      width: mSize.width,
      height: 80.0,
      child: Material(
        color: kColorPrimary,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                getImage(),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: '$luegesName',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22.0,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
