import 'package:aura/models/work_sans.dart';
import 'package:aura/screens/Accountpage.dart';
import 'package:aura/screens/Loginpage.dart';
import 'package:flutter/material.dart';
import 'package:aura/models/day.dart';
import 'package:info_widget/info_widget.dart';
import 'package:provider/provider.dart';
import 'package:aura/models/headache_score.dart';
import 'package:aura/screens/Solutionpage.dart';
import 'package:aura/screens/Metricspage.dart';
import 'package:aura/models/palette.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:intl/intl.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String name = 'User';

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
    loadUserName();
  }

  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'User';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.white,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Aura",
          ),
        ),
        // Drawer
        drawer: Drawer(
          backgroundColor: Palette.softBlue1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Logo
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
                    style: WorkSans.titleSmall,
                  )
                ]),
                SizedBox(
                  height: 20,
                ),
                // To Homepage
                ListTile(
                  leading: Icon(
                    Icons.health_and_safety,
                    color: Palette.deepBlue,
                  ),
                  title: Text(
                    'Aura Score',
                    style: WorkSans.headlineSmall,
                  ),
                  onTap: () {
                    _onItemTapped(0);
                    Navigator.pop(context);
                  },
                ),
                // To Metricspage
                ListTile(
                  leading: Icon(
                    Icons.query_stats,
                    color: Palette.deepBlue,
                  ),
                  title: Text(
                    'Metrics',
                    style: WorkSans.headlineSmall,
                  ),
                  onTap: () {
                    _onItemTapped(1);
                    Navigator.pop(context);
                  },
                ),
                // To Accountpage
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Palette.deepBlue,
                  ),
                  title: Text(
                    'Account',
                    style: WorkSans.headlineSmall,
                  ),
                  onTap: () {
                    _onItemTapped(2);
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                // Logout
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Palette.deepBlue,
                  ),
                  title: Text(
                    'Logout',
                    style: WorkSans.headlineSmall,
                  ),
                  onTap: () async {
                    final sp = await SharedPreferences.getInstance();
                    await sp.remove('access');
                    await sp.remove('refresh');
                    //await sp.remove('name');
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: ((context) => LoginPage())));
                  },
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            // Semicircle behind Scaffold
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: TopSemiCircleClipper(),
                child: Container(
                  // sets height of top panel
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Palette.blue,
                ),
              ),
            ),
            // Homepage elements
            Positioned.fill(
              child: FutureBuilder<HeadacheScore>(
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
                  return Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            DailyScore(
                              score: score,
                              day: day,
                              onItemTapped: _onItemTapped,
                              name: name,
                            ),
                            Metricspage(),
                            Accountpage(),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Palette.white,
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey,
                              blurRadius: 8.0,
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
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopSemiCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.8, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DailyScore extends StatelessWidget {
  final HeadacheScore score;
  final Day day;
  final Function(int) onItemTapped;
  final name;

  DailyScore({
    required this.score,
    required this.day,
    required this.onItemTapped,
    this.name,
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
                    "Welcome, $name",
                    style: WorkSans.displaySmall.copyWith(color: Palette.white),
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
                    AuraScoreIndicator(
                        score: score, day: day, onTap: () => onItemTapped(1)),
                    SizedBox(
                      height: 10,
                    ),
                    FindSolutions(),
                  ],
                )));
              })
            ])));
  }
}

// Sevend day clickable calendar, sets day for AuraScoreIndicator
class SevenDayCalendar extends StatelessWidget {
  Day day;

  SevenDayCalendar({required this.day});
  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = getDateForValue(day.toInt());
    return Container(
        height: 150,
        width: 500,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0,5,0,5),
          child: EasyInfiniteDateTimeLine(
            firstDate: DateTime.now().subtract(Duration(days: 3)),
            focusDate: selectedDate,
            lastDate: DateTime.now().add(Duration(days: 3)),
            timeLineProps:
                EasyTimeLineProps(separatorPadding: 1.0, margin: EdgeInsets.zero),
            dayProps: EasyDayProps(
              inactiveDayStyle: DayStyle(
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border(
                    bottom: BorderSide(width: 2, color: Palette.blue,),
                  ),
                ),
              ),
              todayStyle: DayStyle(
                monthStrStyle: TextStyle(
                  color: Palette.blue
                ),
                dayNumStyle: TextStyle(
                  color: Palette.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
                dayStrStyle: TextStyle(
                  color: Palette.blue
                ),
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border(
                    bottom: BorderSide(width: 2, color: Palette.blue,),
                  ),
                ),
              ),
              activeDayStyle: DayStyle(
                decoration: BoxDecoration(
                  color: Palette.deepBlue,
                  borderRadius: BorderRadius.circular(20),
                )
              ),
            ),
            showTimelineHeader: false,
            onDateChange: (selectedDate) => day.setDay(
                selectedDate, DateTime.now().subtract(Duration(days: 4))),
          ),
        ));
  }
}

// Navigates between days in SevenDayCalendar
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
    String formattedDate = DateFormat('dd/MM/yyyy').format(associatedDate);
    String dayOfWeek = DateFormat('EEEE', 'en_IT').format(associatedDate);

    return Container(
        width: 450,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          /*IconButton(
              onPressed: decrementDay,
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 30,
                color: day.toInt() == 0 ? Palette.transparent : Palette.white,
              )),*/
          Text(
            '$dayOfWeek, $formattedDate',
            style: WorkSans.titleSmall.copyWith(color: Palette.white),
          ),
          /*IconButton(
              onPressed: incrementDay,
              icon: Icon(Icons.arrow_forward_ios,
                  size: 30,
                  color:
                      day.toInt() == 6 ? Palette.transparent : Palette.white)),*/
        ]));
  }
}

// Aura score box indicator, updated on day selection
class AuraScoreIndicator extends StatelessWidget {
  final score;
  final day;
  final VoidCallback onTap;

  AuraScoreIndicator({
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
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Container(
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Your Aura score:",
                    style: WorkSans.titleMedium,
                  ),
                  SizedBox(height: 20,),
                  DashedCircularProgressBar.aspectRatio(
                    aspectRatio: 1.5,
                    valueNotifier: _valueNotifier,
                    progress: score[day.toInt()],
                    maxProgress: 8,
                    startAngle: 225,
                    sweepAngle: 270,
                    foregroundColor: Palette.deepBlue,
                    backgroundColor: Palette.softBlue1,
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
                              style: WorkSans
                                  .displayMedium
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              getText(score[day.toInt()]),
                              style: WorkSans
                                  .titleMedium.copyWith(fontWeight: FontWeight.w300)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      // Info pop-up
            Positioned(
              top: 10,
              right: 10,
              child: InfoWidget(
                infoText: "The score for the upcoming days has been calculated using today's stress score and future weather forecasts.",
                infoTextStyle:
                    WorkSans.bodyMedium.copyWith(color: Palette.deepBlue),
                iconData: Icons.info,
                iconColor: Palette.blue,
              ),
            ),
      // Arrows to control AuraScoreIndicator
            /*
            Positioned(
              left: 0,
              top: 200,
              child: IconButton(
                onPressed: day.decrementDay,
                icon: Icon(
                Icons.arrow_back_ios_new,
                size: 30,
                color: day.toInt() == 0 ? Palette.transparent : Palette.deepBlue,
              )
              ),
            ),
            Positioned(
              right: 0,
              top: 200,
              child: IconButton(
                onPressed: day.incrementDay,
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 30,
                  color: day.toInt() == 6 ? Palette.transparent : Palette.deepBlue,),
              ),
            )*/
          ],
        ),
      ),
    );
  }

// Changes displayed day according to horizontal swipe direction
  void _onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity != null) {
      if (details.primaryVelocity! < 0) {
        day.incrementDay();
      } else if (details.primaryVelocity! > 0) {
        day.decrementDay();
      }
    }
}
}

// Section to go to Solutionpage
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
            SizedBox(height: 15,),
            OutlinedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Solutionpage()));
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Palette.blue,
                  elevation: 5,
                  shadowColor: Palette.softBlue2,
                ),
                child: Text(
                  "Solutions",
                  style: WorkSans.bodyMedium,
                  textScaler: TextScaler.linear(1.7),
                )
              )
          ],
        ),
      ),
    );
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

// To set the color of objects according to the aura score
/*
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
*/
