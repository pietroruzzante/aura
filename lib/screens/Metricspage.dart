import 'package:aura/models/headache_score.dart';
import 'package:aura/models/palette.dart';
import 'package:flutter/material.dart';
import 'package:aura/services/impact.dart';


class Metricspage extends StatelessWidget {
  final impact = Impact();
  final todaySleep = Impact().getTodaySleep();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<String>(
        future: impact.getLastExerciseDate(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error');
          } else {
            final lastDate = snapshot.data;
            return Center(
              child: Column(
                children: [
                Text(
                'Last Date of Exercise: $lastDate',
                style: TextStyle(color: Palette.deepBlue, fontSize: 20, fontWeight: FontWeight.w400)),
                Row(
                  children: [
                    Text('Sleep', style: TextStyle(color: Palette.deepBlue),),
                  ],
                ),
                SleepIndicator(),
              ]),
            );
          }
        },
      ),
    );
  }

}

class SleepIndicator extends StatelessWidget {
  const SleepIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          
      ]
      ));
  }
}