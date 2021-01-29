import 'package:flutter/material.dart';
import 'package:kooramd/widgets/t_shirt_players.dart';

class CardPlayer extends StatelessWidget {
  final namePlayer;
  final numberPlayer;

  CardPlayer({@required this.namePlayer, @required this.numberPlayer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TShirtPlayers(numberPlayer: '$numberPlayer'),
          SizedBox(
            width: 10.0,
          ),
          Text(
            '$namePlayer',
            style: TextStyle(
              fontFamily: 'Tajawal',
              height: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
