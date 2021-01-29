import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kooramd/widgets/t_shirt_players.dart';

class StadiumWidget extends StatelessWidget {
  final playe_1;
  final playe_2;
  final playe_3;
  final playe_4;
  final playe_5;
  final playe_6;
  final playe_7;
  final playe_8;
  final playe_9;
  final playe_10;
  final playe_11;

  StadiumWidget({
    @required this.playe_1,
    @required this.playe_2,
    @required this.playe_3,
    @required this.playe_4,
    @required this.playe_5,
    @required this.playe_6,
    @required this.playe_7,
    @required this.playe_8,
    @required this.playe_9,
    @required this.playe_10,
    @required this.playe_11,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SvgPicture.asset(
          'images/stadium.svg',
          width: 220,
          height: 200.0,
        ),
        Container(
          width: 220,
          height: 200.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Jnab(number: '$playe_3'),
                  Padding(
                      padding: EdgeInsets.only(left: 35.0),
                      child: TShirtPlayers(numberPlayer: '$playe_4')),
                  TShirtPlayers(numberPlayer: '$playe_1'),
                  Padding(
                      padding: EdgeInsets.only(left: 35.0),
                      child: TShirtPlayers(numberPlayer: '$playe_5')),
                  Jnab(number: '$playe_2'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  West(number: '$playe_8'),
                  West(number: '$playe_6'),
                  West(number: '$playe_10'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  West(number: '$playe_7'),
                  Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: West(number: '$playe_9')),
                  West(number: '$playe_11'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Jnab extends StatelessWidget {
  final number;

  Jnab({@required this.number});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 55.0),
            child: TShirtPlayers(numberPlayer: '$number')),
      ],
    );
  }
}

class West extends StatelessWidget {
  final number;

  West({@required this.number});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: TShirtPlayers(numberPlayer: '$number')),
      ],
    );
  }
}
