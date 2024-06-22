import 'dart:ui';

import 'package:aura/models/homepage_widgets/headache_score.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/models/work_sans.dart';
import 'package:aura/services/openWeather.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:aura/services/impact.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:info_widget/info_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Metricspage extends StatefulWidget {
  @override
  _MetricspageState createState() => _MetricspageState();
}

class _MetricspageState extends State<Metricspage> {
  late Future<List<dynamic>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<dynamic>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          } else {
            final data = snapshot.data;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text('Insights',
                              style: WorkSans.titleMedium
                                  .copyWith(color: Palette.deepBlue)),
                          const SizedBox(height: 15),
                          // Aura score chart
                          Text(
                            'Previous scores and forecasting:',
                            style: WorkSans.bodyMedium.copyWith(
                                color: Palette.deepBlue,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: Palette.deepBlue,
                                  blurRadius: 5,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: AspectRatio(
                              aspectRatio: 1.8,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 15, 20, 2),
                                child: LineChart(
                                  duration: const Duration(seconds: 1),
                                  LineChartData(
                                    minX: 0,
                                    maxX: 6,
                                    minY: 0,
                                    maxY: 10,
                                    gridData: const FlGridData(
                                      show: false,
                                      drawVerticalLine: true,
                                    ),
                                    extraLinesData: ExtraLinesData(
                                      verticalLines: [
                                        VerticalLine(
                                          x: 3,
                                          color: Palette.deepBlue,
                                          dashArray: [5, 5],
                                          strokeWidth: 1,
                                        ),
                                      ],
                                    ),
                                    titlesData: FlTitlesData(
                                      // numbers for graph
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 20,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                              value.toInt().toString(),
                                              style: WorkSans.bodyMedium
                                                  .copyWith(color: Colors.grey, fontWeight: FontWeight.w400),
                                            );
                                          },
                                          interval: 2,
                                        ),
                                      ),
                                      rightTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      topTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      // days of the week
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 30,
                                          getTitlesWidget: (value, meta) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Text(
                                                dayOfWeek(value),
                                                style: WorkSans.bodyMedium
                                                    .copyWith(
                                                        color: Colors.grey, fontWeight: FontWeight.w400),
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
                                    // graph line and dots
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
                                        isCurved: true,
                                        barWidth: 3,
                                        color: Colors.blue,
                                        isStrokeCapRound: false,
                                        dotData: FlDotData(
                                          show: true,
                                          getDotPainter: (FlSpot spot,
                                              double percent,
                                              LineChartBarData bar,
                                              int index) {
                                            return FlDotCirclePainter(
                                              radius: 4,
                                              color: Palette.deepBlue,
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
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Today\'s score composition:',
                            style: WorkSans.bodyMedium.copyWith(
                                color: Palette.deepBlue,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Palette.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 5,
                                    color: Palette.softBlue2,
                                  )
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Stress
                                  Column(
                                    children: [
                                      DashedCircularProgressBar(
                                        width: 75,
                                        height: 75,
                                        progress: data[1][3],
                                        maxProgress: 6,
                                        startAngle: 225,
                                        sweepAngle: 270,
                                        foregroundColor: Palette.deepBlue,
                                        backgroundColor: Palette.softBlue1,
                                        foregroundStrokeWidth: 6,
                                        backgroundStrokeWidth: 6,
                                        seekColor: Palette.white,
                                        seekSize: 5,
                                        animation: true,
                                        animationDuration:
                                            const Duration(milliseconds: 500),
                                        animationCurve:
                                            Easing.standardDecelerate,
                                        child: Center(
                                            child: Text(
                                          '${data[1][3].toInt()}/6',
                                          style: WorkSans.bodyMedium.copyWith(
                                              color: Palette.deepBlue,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      const Text('stress',
                                          style: WorkSans.headlineSmall),
                                    ],
                                  ),
                                  // Weather
                                  Column(
                                    children: [
                                      DashedCircularProgressBar(
                                        width: 75,
                                        height: 75,
                                        startAngle: 225,
                                        sweepAngle: 270,
                                        progress: data[2][3],
                                        maxProgress: 4,
                                        foregroundColor: Palette.deepBlue,
                                        backgroundColor: Palette.softBlue1,
                                        foregroundStrokeWidth: 6,
                                        backgroundStrokeWidth: 6,
                                        seekColor: Palette.white,
                                        seekSize: 5,
                                        animation: true,
                                        animationDuration:
                                            const Duration(milliseconds: 500),
                                        animationCurve:
                                            Easing.standardDecelerate,
                                        child: Center(
                                            child: Text(
                                          '${data[2][3].toInt()}/4',
                                          style: WorkSans.bodyMedium.copyWith(
                                              color: Palette.deepBlue,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      const Text('weather',
                                          style: WorkSans.headlineSmall),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // Exercise
                          const Text('Exercise', style: WorkSans.titleSmall),
                          Text(
                            'Your last workout session was on:',
                            style:
                                WorkSans.headlineSmall.copyWith(fontSize: 16),
                          ),
                          // Last exercise container
                          Container(
                            height: 30,
                            width: MediaQuery.sizeOf(context).width - 60,
                            decoration: BoxDecoration(
                                color: Palette.softBlue1,
                                borderRadius: BorderRadius.circular(20)),
                            child: Stack(children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(lastDayOfWorkOut(data[3]),
                                    style: WorkSans.bodyMedium.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Palette.deepBlue)),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: InfoWidget(
                                      infoText:
                                          'Research says that you should exercise at least 3 times a week for 30 minutes to avoid headaches',
                                      infoTextStyle: WorkSans.bodyMedium
                                          .copyWith(color: Palette.deepBlue),
                                      iconData: Icons.info,
                                      iconColor: Palette.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getExerciseText(data[3]),
                                style: WorkSans.bodyMedium
                                    .copyWith(color: Palette.deepBlue),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          // Sleep
                          const Text('Sleep', style: WorkSans.titleSmall),
                          SleepIndicator(todaySleep: data[0], age: data[8]),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getSleepText(data[0], data[8]),
                                style: WorkSans.bodyMedium
                                    .copyWith(color: Palette.deepBlue),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          // Weather
                          const Text('Weather', style: WorkSans.titleSmall),
                          Text(
                            'About today\'s weather:',
                            style:
                                WorkSans.headlineSmall.copyWith(fontSize: 16),
                          ),
                          Container(
                            height: 40,
                            width: MediaQuery.sizeOf(context).width - 60,
                            decoration: BoxDecoration(
                                color: Palette.softBlue1,
                                borderRadius: BorderRadius.circular(20)),
                            child: Stack(children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text('pressure: ${data[9]} mb',
                                    style: WorkSans.bodyMedium.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Palette.deepBlue)),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: data[9] > 1010
                                      ? const Icon(
                                          Icons.wb_sunny_outlined,
                                        )
                                      : const Icon(
                                          Icons.cloud, 
                                        ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: InfoWidget(
                                      infoText:
                                          'Low atmospheric pressure contributes to increasing the risk of headaches',
                                      infoTextStyle: WorkSans.bodyMedium
                                          .copyWith(color: Palette.deepBlue),
                                      iconData: Icons.info,
                                      iconColor: Palette.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
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
      return "You didn't sleep enough! :()";
    } else {
      return "Well Done! You slept enough :)";
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
        return "Well Done! Keep working out :)";
      } else {
        return "You haven't worked out enough! :(";
      }
    }
  }

  Future<List<dynamic>> loadData(BuildContext context) async {
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
    final pressure = getPressureFromTimestamp(
            unixDates()[3],
            await Openweather().getData(await Openweather()
                .getCoordinates(await int.parse(prefs.getString('zipCode')!))),
            'current')
        .toInt();

    if (todaySleep == 0 || lastDateExercise == 'Not available data') {
      _showErrorToast(context);
    }
    return [
      todaySleep,
      todayStress,
      todayWeather,
      lastDateExercise,
      score,
      day0,
      day1,
      day2,
      age,
      pressure
    ];
  }
}

class SleepIndicator extends StatelessWidget {
  final dynamic todaySleep;
  final dynamic age;

  const SleepIndicator({
    super.key,
    required this.todaySleep,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last night you slept ${todaySleep.toInt()} hours!',
            style: WorkSans.headlineSmall.copyWith(fontSize: 16),
          ),
          Container(
              height: 30,
              width: MediaQuery.sizeOf(context).width - 60,
              decoration: BoxDecoration(
                color: Palette.softBlue1,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 40,
                  ),
                  child: SleepBar(todaySleep: todaySleep, age: age),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Transform.scale(
                    scale: 0.8,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: InfoWidget(
                        infoText:
                            'Based on your age, you should sleep at least ${reccomendedSleepHours(age)} hours per night',
                        infoTextStyle: WorkSans.bodyMedium
                            .copyWith(color: Palette.deepBlue),
                        iconData: Icons.info,
                        iconColor: Palette.blue,
                      ),
                    ),
                  ),
                ),
              ])),
        ]);
  }
}

class SleepBar extends StatefulWidget {
  final double todaySleep;
  final int age;
  const SleepBar({super.key, required this.todaySleep, required this.age});
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
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: false);

    _animation = Tween<double>(
            begin: 0,
            end: ((widget.todaySleep)/reccomendedSleepHours(widget.age)))
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
            minHeight: 10,
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

String lastDayOfWorkOut(String lastDateExercise) {
  if (lastDateExercise == 'Not available data') {
    return lastDateExercise;
  } else {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    DateTime parsedDate = dateFormat.parse(lastDateExercise);
    String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    String dayOfWeek = DateFormat('EEEE', 'en_IT').format(parsedDate);
    return '$dayOfWeek, $formattedDate';
  }
}

void _showErrorToast(BuildContext context) {
  CherryToast.warning(
    height: 100,
    width: 400,
    title: const Text(
      'Warning!',
      style: WorkSans.titleSmall,
    ),
    description: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Some data are not available',
            style: WorkSans.headlineSmall.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
      textAlign: TextAlign.left,
    ),
    displayIcon: true,
    animationType: AnimationType.fromTop,
    animationDuration: const Duration(seconds: 1),
    toastDuration: const Duration(seconds: 5),
    inheritThemeColors: true,
    autoDismiss: true,
  ).show(context);
}
