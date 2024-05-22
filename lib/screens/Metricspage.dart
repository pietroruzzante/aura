import 'package:aura/models/headache_score.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/models/workSans.dart';
import 'package:flutter/material.dart';
import 'package:aura/services/impact.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';

class Metricspage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<dynamic>(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error');
          } else {
            final data = snapshot.data;
            return Center(
              child: Container(
                width: 300,
                height: 500,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 300,
                        width: 400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Aura score insights',
                                        style: WorkSans.titleMedium
                                            .copyWith(color: Palette.white)),
                                  ],
                                ),
                                SizedBox(height: 100),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                                'stress',
                                                style: WorkSans.titleSmall
                                                .copyWith(color: Palette.deepBlue)),
                                            DashedCircularProgressBar(
                                              width: 100,
                                              height: 100,
                                              progress: data[1][3],
                                              maxProgress: 4,
                                              startAngle: 225,
                                              sweepAngle: 270,
                                              foregroundColor: Palette.deepBlue,
                                              backgroundColor: Palette.softBlue1,
                                              foregroundStrokeWidth: 10,
                                              backgroundStrokeWidth: 10,
                                              seekColor: Palette.white,
                                              seekSize: 8,
                                              animation: true,
                                              animationDuration:
                                                  Duration(milliseconds: 500),
                                              animationCurve:
                                                  Easing.standardDecelerate,
                                              child: Center(child: Text('${data[1][3].toInt()}')),
                                            )
                                          ],
                                        ),
                                        SizedBox(width: 10,),
                                        Column(
                                          children: [
                                            Text(
                                                'weather',
                                                style: WorkSans.titleSmall
                                                .copyWith(color: Palette.deepBlue)),
                                            DashedCircularProgressBar(
                                              width: 100,
                                              height: 100,
                                              startAngle: 225,
                                              sweepAngle: 270,
                                              progress: data[2][3],
                                              maxProgress: 4,
                                              foregroundColor: Palette.deepBlue,
                                              backgroundColor: Palette.softBlue1,
                                              foregroundStrokeWidth: 10,
                                              backgroundStrokeWidth: 10,
                                              seekColor: Palette.white,
                                              seekSize: 8,
                                              animation: true,
                                              animationDuration:
                                                  Duration(milliseconds: 500),
                                              animationCurve:
                                                  Easing.standardDecelerate,
                                              child: Center(child: Text('${data[2][3].toInt()}')),
                                            ),
                                            
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Exercise', style: WorkSans.titleSmall),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Last Date of Exercise: ${data[3]}',
                                    style: WorkSans.headlineSmall
                                        .copyWith(fontSize: 16)),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 70,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Sleep', style: WorkSans.titleSmall),
                              ],
                            ),
                            SleepIndicator(todaySleep: data[0]),
                          ],
                        ),
                      ),
                    ]),
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<dynamic>> loadData() async {
    final impact = Impact();
    final todaySleep = await impact.getTodaySleep();
    final todayStress = await HeadacheScore().getStress();
    final todayWeather = await HeadacheScore().getWeather();
    final lastDateExercise = await impact.getLastExerciseDate();
    return [todaySleep, todayStress, todayWeather, lastDateExercise];
  }
}

class SleepIndicator extends StatelessWidget {
  final todaySleep;

  const SleepIndicator({
    super.key,
    required this.todaySleep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          LinearProgressIndicator(
            value: (todaySleep!) / 12,
            minHeight: 10.0,
            borderRadius: BorderRadius.circular(5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'You slept ${todaySleep.toInt()} hours',
                style: WorkSans.headlineSmall,
              ),
            ],
          )
        ]));
  }
}
