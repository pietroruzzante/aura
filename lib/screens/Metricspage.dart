import 'package:aura/models/headache_score.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/models/work_sans.dart';
import 'package:flutter/material.dart';
import 'package:aura/services/impact.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:fl_chart/fl_chart.dart';
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
                                  color: Palette.softBlue2,
                                  blurRadius: 1,
                                ),
                              ],
                              color: Palette.white,
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
                                            x: 3, // Quarto valore sull'asse X
                                            color: Palette.deepBlue,
                                            dashArray: [
                                              5,
                                              5
                                            ], // Linea tratteggiata
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
                                            isCurved: true,
                                            barWidth: 4,
                                            color: Palette.deepBlue,
                                            isStrokeCapRound: true,
                                            dotData: FlDotData(
                                                show: true,
                                                getDotPainter: (FlSpot spot,
                                                    double percent,
                                                    LineChartBarData bar,
                                                    int index) {
                                                  return FlDotCirclePainter(
                                                    radius:
                                                        5, // Dimensione dei punti
                                                    color: Palette
                                                        .deepBlue, // Colore dei punti
                                                    strokeWidth: 0,
                                                  );
                                                }),
                                            belowBarData: BarAreaData(
                                              show: false,
                                            ),
                                            aboveBarData:
                                                BarAreaData(show: false)),
                                      ],
                                    ),
                                  ),
                                )),
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
                                            child:
                                                Text('${data[1][3].toInt()}')),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
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
                                            child:
                                                Text('${data[2][3].toInt()}')),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
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
                              Text('Last Date of Exercise: ${data[3]}',
                                  style: WorkSans.headlineSmall
                                      .copyWith(fontSize: 16)),
                            ],
                          )
                        ],
                      ),
                      Column(
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final day0 = prefs.getDouble('day0');
    final day1 = prefs.getDouble('day1');
    final day2 = prefs.getDouble('day2');
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
      day2
    ];
  }
String dayOfWeek(double value) {
    final today = DateTime.now();
    final currentDay = today.weekday;
    final daysOfWeek = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    final adjustedDay = (currentDay + (value.toInt() - 3)) % 7;
    return daysOfWeek[adjustedDay < 0 ? adjustedDay + 7 : adjustedDay];
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
