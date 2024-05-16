import 'package:flutter/material.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/models/solution.dart';

class SolutionCard extends StatelessWidget {
  Solution solution;

  SolutionCard({required this.solution});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => solution.pageRoute));
      },
      child: Container(
        height: 200,
        child: Card(
          //semanticContainer: true,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
          color: Palette.white,
          elevation: 5,
          shadowColor: Palette.darkBlue,
          child: Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                    solution.imagePath,
                    fit: BoxFit.contain,
                ),
              ),
            ),
                /*Text(
                solution.name,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),*/
          ),
        )
      ),
    );
  }
}
