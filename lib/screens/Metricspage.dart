import 'package:aura/models/palette.dart';
import 'package:aura/models/workSans.dart';
import 'package:flutter/material.dart';
import 'package:aura/services/impact.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';

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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Aura score insights',
                                    style:
                                        WorkSans.titleMedium.copyWith(color: Palette.white))
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
                                Text('Last Date of Exercise: $lastDate',
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
                            SleepIndicator(todaySleep: todaySleep),
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
}

class SleepIndicator extends StatelessWidget {
  final todaySleep;

  const SleepIndicator({
    super.key,
    required this.todaySleep,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
        future: todaySleep,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error');
          } else {
            final todaySleepDuration = snapshot.data;
            return Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  LinearProgressIndicator(
                    value: (todaySleepDuration!) / 12,
                    minHeight: 10.0,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'You slept ${todaySleepDuration.toInt()} hours',
                        style: WorkSans.headlineSmall,
                      ),
                    ],
                  )
                ]));
          }
        });
  }
}
