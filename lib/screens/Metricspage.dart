import 'package:aura/models/headache_score.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/models/work_sans.dart';
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
                        height: 250,
                        child: Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Aura score insights',
                                    style:
                                        WorkSans.titleMedium.copyWith(color: Palette.white)),
                                Text('stress score: ${data[1][3]} '),
                                Text('stress score: ${data[2][3]}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50,),
                      Container(
                        height: 90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Exercise',
                                    style:
                                        WorkSans.titleSmall),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Last Date of Exercise: ${data[3]}',
                                    style: WorkSans.headlineSmall.copyWith(fontSize: 16)),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 90,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Sleep',
                                    style:
                                        WorkSans.titleSmall),
                              ],
                            ),
                            SizedBox(
                              height: 20,
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
