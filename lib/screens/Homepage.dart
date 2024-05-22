import 'package:aura/models/workSans.dart';
import 'package:aura/screens/Accountpage.dart';
import 'package:flutter/material.dart';
import 'package:aura/models/day.dart';
import 'package:provider/provider.dart';
import 'package:aura/models/headache_score.dart';
import 'package:aura/screens/Solutionpage.dart';
import 'package:aura/screens/Metricspage.dart';
import 'package:aura/models/palette.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:intl/intl.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:timeline_calendar/calendar/timeline_calendar.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  int currentIndex = 0;
  late TabController tabController;

  final score = HeadacheScore().refreshScore();
  final day = Day();

  List<BottomNavigationBarItem> navBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.health_and_safety),
      label: 'Aura Score',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.query_stats),
      label: 'Metrics',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Account',
    ),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        setState(() {
          currentIndex = tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int newIndex) {
    setState(() {
      currentIndex = newIndex;
    });
    tabController.animateTo(newIndex);
  }

  Widget _selectPage(int index, HeadacheScore score, Day day) {
    switch (index) {
      case 0:
        return DailyScore(score: score, day: day, onItemTapped: _onItemTapped);
      case 1:
        return Metricspage();
      case 2:
        return Accountpage();
      default:
        return DailyScore(score: score, day: day, onItemTapped: _onItemTapped);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Palette.white,
            Palette.softBlue1,
          ],
        ),
      ),
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Aura",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Palette.deepBlue),
            ),
          ),
          // Drawer
          drawer: Drawer(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Row(children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 50,
                      width: 50,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Aura',
                      style: Theme.of(context).textTheme.titleSmall,
                    )
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.health_and_safety,
                      color: Palette.deepBlue,
                    ),
                    title: Text(
                      'Aura Score',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    onTap: () {
                      _onItemTapped(0);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.query_stats,
                      color: Palette.deepBlue,
                    ),
                    title: Text(
                      'Metrics',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    onTap: () {
                      _onItemTapped(1);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Palette.deepBlue,
                    ),
                    title: Text(
                      'Account',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    onTap: () {
                      _onItemTapped(2);
                      Navigator.pop(context);
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Palette.deepBlue,
                    ),
                    title: Text(
                      'Logout',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    onTap: () => {},
                  ),
                ],
              ),
            ),
          ),
          body: FutureBuilder<HeadacheScore>(
              future: score,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('Error: ${snapshot.error}');
                }
                final HeadacheScore score = snapshot.data!;
                return Stack(
                  children: [
                    TabBarView(
                      controller: tabController,
                      children: [
                        DailyScore(
                            score: score,
                            day: day,
                            onItemTapped: _onItemTapped),
                        Metricspage(),
                        Accountpage(),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Palette.white,
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey,
                              blurRadius: 10.0,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: BottomNavigationBar(
                          currentIndex: currentIndex,
                          onTap: _onItemTapped,
                          items: navBarItems,
                          backgroundColor: Palette.transparent,
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                );
                //return _selectPage(index, score, day);
              })),
    );
  }
}

class DailyScore extends StatelessWidget {
  final HeadacheScore score;
  final Day day;
  final Function(int) onItemTapped;

  DailyScore({
    required this.score,
    required this.day,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: 350,
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text(
                    "Welcome",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                )
              ]),
              SizedBox(
                height: 10,
              ),
              Consumer<Day>(builder: (context, day, child) {
                return Center(
                    child: FittedBox(
                        child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DayArrows(
                        incrementDay: day.incrementDay,
                        decrementDay: day.decrementDay,
                        day: day),
                    SevenDayCalendar(day: day),
                    MyGaugeIndicator(
                        score: score, day: day, onTap: () => onItemTapped(1)),
                    solutionsHomepage(),
                  ],
                )));
              })
            ])));
  }
}

class SevenDayCalendar extends StatelessWidget {
  final day;
  DateTime selectedDate = DateTime.now();

  SevenDayCalendar({required this.day});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        width: 500,
        child: EasyInfiniteDateTimeLine(
          firstDate: DateTime.now().subtract(Duration(days: 3)),
          focusDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 3)),
          timeLineProps:
              EasyTimeLineProps(separatorPadding: 1.0, margin: EdgeInsets.zero),
          dayProps: EasyDayProps(),
          showTimelineHeader: false,
          onDateChange: (selectedDate) => day.setDay(
              selectedDate, DateTime.now().subtract(Duration(days: 4))),
          activeColor: Palette.deepBlue,
        ));
  }
}

class DayArrows extends StatelessWidget {
  final VoidCallback incrementDay;
  final VoidCallback decrementDay;
  final day;

  DayArrows(
      {required this.incrementDay,
      required this.decrementDay,
      required this.day});

  @override
  Widget build(BuildContext context) {
    DateTime associatedDate = getDateForValue(day.toInt());
    String formattedDate = DateFormat('dd MM yyyy').format(associatedDate);
    String dayOfWeek = DateFormat('EEEE', 'en_IT').format(associatedDate);

    return Container(
        width: 450,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IconButton(
              onPressed: decrementDay,
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 30,
                color: day.toInt() == 0 ? Palette.transparent : Colors.black,
              )),
          Text(
            '$dayOfWeek, $formattedDate',
            style: WorkSans.titleSmall,
          ),
          IconButton(
              onPressed: incrementDay,
              icon: Icon(Icons.arrow_forward_ios,
                  size: 30,
                  color:
                      day.toInt() == 6 ? Palette.transparent : Colors.black)),
        ]));
  }
}

class solutionsHomepage extends StatelessWidget {
  const solutionsHomepage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "What can you do?",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Solutionpage(
                              needSleep: true,
                              needExercise: true,
                            )));
              },
              label: Text(
                "Solutions",
                textScaler: TextScaler.linear(1.7),
              ))
        ],
      ),
      height: 100,
      width: 450,
      decoration: BoxDecoration(
        color: Palette.transparent,
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}

class MyGaugeIndicator extends StatelessWidget {
  final score;
  final day;
  final VoidCallback onTap;

  MyGaugeIndicator({
    required this.score,
    required this.day,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> _valueNotifier =
        ValueNotifier(score[day.toInt()]);
    return GestureDetector(
        onTap: onTap,
        child: Container(
            height: 450,
            width: 480,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Palette.softBlue1,
                  blurRadius: 10,
                )
              ],
              color: Palette.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Your Aura score:",
                    style: WorkSans.titleMedium,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DashedCircularProgressBar.aspectRatio(
                          aspectRatio: 1.5,
                          valueNotifier: _valueNotifier,
                          progress: score[day.toInt()],
                          maxProgress: 8,
                          startAngle: 225,
                          sweepAngle: 270,
                          foregroundColor: Palette.deepBlue,
                          backgroundColor: Palette.white,
                          foregroundStrokeWidth: 15,
                          backgroundStrokeWidth: 15,
                          animation: true,
                          animationDuration: Duration(milliseconds: 500),
                          animationCurve: Easing.standardDecelerate,
                          seekSize: 10,
                          seekColor: Palette.white,
                          child: Center(
                            child: ValueListenableBuilder(
                                valueListenable: _valueNotifier,
                                builder: (_, double value, __) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${value.toInt()}/8',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          getText(score[day.toInt()]),
                                          style: TextStyle(
                                              color: Palette.deepBlue,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 30),
                                        ),
                                      ],
                                    )),
                          ),
                        )
                      ])
                ])));
  }
}

Color getButtonColor(double score) {
  if (score < 2) {
    return Palette.lightBlue1;
  } else if ((score >= 2) & (score < 4)) {
    return Palette.lightBlue4;
  } else if ((score >= 4) & (score < 6)) {
    return Palette.blue;
  } else {
    return Palette.yellow;
  }
}

String getText(double score) {
  if (score < 2) {
    return "Low level";
  } else if ((score >= 2) & (score < 4)) {
    return "Medium level";
  } else if ((score >= 4) & (score < 6)) {
    return "High level";
  } else {
    return "Your level is very high!";
  }
}

DateTime getDateForValue(int value) {
  DateTime now = DateTime.now();
  int difference = value - 3; // 3 è il valore centrale che rappresenta oggi
  return now.add(Duration(days: difference));
}
