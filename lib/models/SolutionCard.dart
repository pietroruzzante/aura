import 'package:flutter/material.dart';
import 'package:stress/models/palette.dart';
import 'package:stress/models/solution.dart';

class SolutionCard extends StatelessWidget {
  Solution solution;

  SolutionCard({super.key, required this.solution});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        color: Palette.blue,
        elevation: 5,
        shadowColor: Palette.darkBlue,
        child: Column(children: [
          Image.asset(
            solution.imagePath,
            fit: BoxFit.fill,
          ),
          /*Text(
            solution.name,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),*/
        ]),
      ),
    );
  }
}
