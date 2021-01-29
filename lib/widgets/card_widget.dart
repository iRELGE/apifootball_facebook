import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final Color colour;
  CardWidget({@required this.colour});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      height: 30.0,
      color: colour,
    );
  }
}
