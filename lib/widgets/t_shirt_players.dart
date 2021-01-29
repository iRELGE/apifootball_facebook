import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TShirtPlayers extends StatelessWidget {
  final numberPlayer;

  TShirtPlayers({this.numberPlayer});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SvgPicture.asset(
          'images/t_shirt.svg',
          width: 32.0,
          height: 32.0,
        ),
        SizedBox(
          height: 30.0,
          width: 30.0,
          child: Center(
            child: Text(
              '$numberPlayer',
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
                height: 1.5,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
