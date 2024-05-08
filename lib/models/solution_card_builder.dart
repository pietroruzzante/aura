import 'package:flutter/material.dart';
import 'package:stress/models/palette.dart';

class SolutionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        color: Palette.blue,
        elevation: 5,
        shadowColor: Palette.darkBlue,
      ),
    );
  }
}
