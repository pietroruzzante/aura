import 'package:flutter/material.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/models/solution.dart';

class SolutionCard extends StatelessWidget {
  final Solution solution;

  const SolutionCard({super.key, required this.solution});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => solution.open(context),
      child: SizedBox(
        height: 225,
        width: 300,
        child: Card(
          //semanticContainer: true,
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
          color: Palette.white,
          elevation: 10,
          shadowColor: Palette.softBlue2,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                  solution.imagePath,
                  fit: BoxFit.contain,
              ),
            ),
          ),
        )
      ),
    );
  }
}
