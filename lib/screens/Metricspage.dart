import 'package:aura/models/palette.dart';
import 'package:flutter/material.dart';
import 'package:aura/services/impact.dart';


class Metricspage extends StatelessWidget {
  final impact = Impact();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: impact.getLastExerciseDate(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error');
        } else {
          final lastDate = snapshot.data;
          return Center(
            child: Text(
              'Last Date of Exercise: $lastDate',
              style: TextStyle(color: Palette.deepBlue, fontSize: 20, fontWeight: FontWeight.w400),
            ),
          );
        }
      },
    );
  }
}


