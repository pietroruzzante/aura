import 'package:aura/models/palette.dart';
import 'package:aura/models/work_sans.dart';
import 'package:aura/screens/Solutionpage.dart';
import 'package:flutter/material.dart';

class FindSolutions extends StatelessWidget {
  const FindSolutions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Palette.softBlue2,
            blurRadius: 10,
          ),
        ],
        color: Palette.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "What can you do?",
              style: WorkSans.titleMedium.copyWith(fontSize: 24),
            ),
            SizedBox(
              height: 15,
            ),
            FilledButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Solutionpage()));
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Palette.blue,
                  elevation: 5,
                  shadowColor: Palette.softBlue2,
                ),
                child: Text(
                  "Solutions",
                  style: WorkSans.bodyMedium,
                  textScaler: TextScaler.linear(1.7),
                ))
          ],
        ),
      ),
    );
  }
}
