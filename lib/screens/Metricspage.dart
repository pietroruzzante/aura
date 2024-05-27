import 'dart:ui';

import 'package:aura/models/headache_score.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/models/work_sans.dart';
import 'package:flutter/material.dart';
import 'package:aura/services/impact.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:info_widget/info_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                height: 1000,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Aura score insights',
                                  style: WorkSans.titleMedium
                                      .copyWith(color: Palette.white)),
                            ],
                          ),
                          //SizedBox(height: 100),
                          Container(
                            width: 600,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: AspectRatio(
                              aspectRatio: 1.8,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: 25,
                                  left: 20,
                                  top: 24,
                                  bottom: 15,
                                ),
                                child: LineChart(
                                  duration: Duration(milliseconds: 1000),
                                  LineChartData(
                                    minX: 0,
                                    maxX: 6,
                                    minY: 0,
                                    maxY: 8,
                                    gridData: FlGridData(
                                      show: false,
                                      drawVerticalLine: true,
                                      getDrawingHorizontalLine: (value) {
                                        return FlLine(
                                          color: const Color(0xffe7e8ec),
                                          strokeWidth: 1,
                                        );
                                      },
                                      getDrawingVerticalLine: (value) {
                                        return FlLine(
                                          color: const Color(0xffe7e8ec),
                                          strokeWidth: 1,
                                        );
                                      },
                                    ),
                                    extraLinesData: ExtraLinesData(
                                      verticalLines: [
                                        VerticalLine(
                                          x: 3,
                                          color: Palette.deepBlue,
                                          dashArray: [5, 5],
                                          strokeWidth: 2,
                                        ),
                                      ],
                                    ),
                                    titlesData: FlTitlesData(
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 40,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                              value.toInt().toString(),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            );
                                          },
                                          interval: 2,
                                        ),
                                      ),
                                      rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      topTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 30,
                                          getTitlesWidget: (value, meta) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  dayOfWeek(value),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                            );
                                          },
                                          interval: 1,
                                        ),
                                      ),
                                    ),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: [
                                          FlSpot(0, data[5]),
                                          FlSpot(1, data[6]),
                                          FlSpot(2, data[7]),
                                          FlSpot(3, data[4][3]),
                                          FlSpot(4, data[4][4]),
                                          FlSpot(5, data[4][5]),
                                          FlSpot(6, data[4][6]),
                                        ],
                                        isCurved: false,
                                        barWidth: 4,
                                        color: Colors.blue,
                                        isStrokeCapRound: true,
                                        dotData: FlDotData(
                                          show: true,
                                          getDotPainter: (FlSpot spot,
                                              double percent,
                                              LineChartBarData bar,
                                              int index) {
                                            return FlDotCirclePainter(
                                              radius: 5,
                                              color: Palette.deepBlue,
                                              strokeWidth: 0,
                                            );
                                          },
                                        ),
                                        belowBarData: BarAreaData(show: false),
                                        aboveBarData: BarAreaData(show: false),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text('stress',
                                          style: WorkSans.titleSmall.copyWith(
                                              color: Palette.deepBlue)),
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
                                        child: Center(
                                            child: Text(
                                                '${data[1][3].toInt()}/4')),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    children: [
                                      Text('weather',
                                          style: WorkSans.titleSmall.copyWith(
                                              color: Palette.deepBlue)),
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
                                        child: Center(
                                            child: Text(
                                                '${data[2][3].toInt()}/4')),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Column(
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
                                Text('Your last workout session was:',
                                    style: WorkSans.headlineSmall
                                        ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(lastDayOfWorkOut(data[3]),
                                    style: WorkSans.headlineSmall.copyWith(fontWeight: FontWeight.w700)
                                        ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(getExerciseText(data[3]),
                                        style: WorkSans.headlineSmall,)
                                           
                              ],
                            ),
                          ],
                        ),
                       Positioned(
                        right: 0,
                         child: InfoWidget(
                                  infoText:
                                      'Research says that you should exercise at least 3 times a week for 30 minutes to avoid headaches',
                                  infoTextStyle: WorkSans.bodyMedium
                                      .copyWith(color: Palette.deepBlue),
                                  iconData: Icons.info,
                                  iconColor: Palette.blue,
                                ),
                       ),
                    ]
                    ),
                      Stack(children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Sleep', style: WorkSans.titleSmall),
                              ],
                            ),
                            SleepIndicator(todaySleep: data[0], age: data[8]),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  getSleepText(data[0], data[8]),
                                  style: WorkSans.headlineSmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          right: 0,
                          child: InfoWidget(
                            infoText:
                                'Based on your age, you should sleep at least ${reccomendedSleepHours(data[8])} hours per night',
                            infoTextStyle: WorkSans.bodyMedium
                                .copyWith(color: Palette.deepBlue),
                            iconData: Icons.info,
                            iconColor: Palette.blue,
                          ),
                        ),
                      ]),
                    ]),
              ),
            );
          }
        },
      ),
    );
  }

  String getSleepText(double todaySleep, int age) {
    int sleepNeeded;
    if (age <= 12) {
      sleepNeeded = 9;
    } else if (age >= 13 && age <= 18) {
      sleepNeeded = 8;
    } else {
      sleepNeeded = 7;
    }
    if (todaySleep < sleepNeeded) {
      return "You didn't sleep enough!";
    } else {
      return "Well Done! You slept enough";
    }
  }

  String getExerciseText(String lastDateExercise) {
    if (lastDateExercise == 'Not available data') {
      return ' ';
    } else {
      DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      DateTime parsedDate = dateFormat.parse(lastDateExercise);

      DateTime currentDate = DateTime.now();
      int differenceInDays = currentDate.difference(parsedDate).inDays;

      if (differenceInDays.abs() < 3) {
        return "Well Done! keep working out";
      } else {
        return "You haven't worked out enough!";
      }
    }
  }

  Future<List<dynamic>> loadData() async {
    final impact = Impact();
    final todaySleep = await impact.getTodaySleep();
    final todayStress = await HeadacheScore().getStress();
    final todayWeather = await HeadacheScore().getWeather();
    final lastDateExercise = await impact.getLastExerciseDate();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final day0 = prefs.getDouble('day0');
    final day1 = prefs.getDouble('day1');
    final day2 = prefs.getDouble('day2');
    final age = int.parse(prefs.getString('age')!);
    final score = List.generate(todayWeather.length,
        (index) => todayWeather[index] + todayStress[index]);
    return [
      todaySleep,
      todayStress,
      todayWeather,
      lastDateExercise,
      score,
      day0,
      day1,
      day2,
      age
    ];
  }
}

class SleepIndicator extends StatelessWidget {
  final todaySleep;
  final age;

  const SleepIndicator({
    super.key,
    required this.todaySleep,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          SleepBar(todaySleep: todaySleep, age: age),
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

class SleepBar extends StatefulWidget {
  final double todaySleep;
  final int age;
  SleepBar({required this.todaySleep, required this.age});
  @override
  SleepBarState createState() => SleepBarState();
}

class SleepBarState extends State<SleepBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: false);

    _animation = Tween<double>(
            begin: 0,
            end: widget.todaySleep / reccomendedSleepHours(widget.age))
        .animate(_controller);

    CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return LinearProgressIndicator(
            value: _animation.value,
            minHeight: 10.0,
            borderRadius: BorderRadius.circular(5),
          );
        },
      ),
    );
  }
}

String dayOfWeek(double value) {
  final today = DateTime.now();
  final currentDay = today.weekday;
  final daysOfWeek = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
  final adjustedDay = (currentDay + (value.toInt() - 3)) % 7;
  return daysOfWeek[adjustedDay < 0 ? adjustedDay + 7 : adjustedDay];
}

int reccomendedSleepHours(int age) {
  int sleepNeeded;
  if (age <= 12) {
    sleepNeeded = 9;
  } else if (age >= 13 && age <= 18) {
    sleepNeeded = 8;
  } else {
    sleepNeeded = 7;
  }
  return sleepNeeded;
}

String lastDayOfWorkOut(String lastDateExercise){
  if (lastDateExercise == 'Not available data'){
    return lastDateExercise;
  } else {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    DateTime parsedDate = dateFormat.parse(lastDateExercise);
    String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    String dayOfWeek = DateFormat('EEEE', 'en_IT').format(parsedDate);
    return '$dayOfWeek, $formattedDate';
  }
}
