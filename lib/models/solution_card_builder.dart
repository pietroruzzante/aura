import 'package:flutter/material.dart';
import 'package:stress/models/palette.dart';

class SolutionCard extends StatelessWidget {
  final String cardTitle;

  const SolutionCard({super.key, required this.cardTitle});

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
        child: Center(
          child: Text(
            cardTitle,
            style: const TextStyle(fontSize: 16, color: Colors.white),
            )
        ),
      ),
    );
  }
}
