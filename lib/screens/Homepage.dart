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

import '../models/aura_score_indicator.dart';
import '../models/day_arrows.dart';
import '../models/find_solutions.dart';
import '../models/seven_day_calendar.dart';

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
                            Center(
                                child: SizedBox(
                                    width: 350,
                                    child: Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 10, 0),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  "Welcome, $name",
                                                  style: WorkSans.displaySmall
                                                      .copyWith(
                                                          color: Palette.white),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Image.asset(
                                              'assets/waving-hand_1f44b.png',
                                              scale: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Consumer<Day>(
                                          builder: (context, day, child) {
                                        return Center(
                                            child: FittedBox(
                                                child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            DayArrows(
                                                incrementDay: day.incrementDay,
                                                decrementDay: day.decrementDay,
                                                day: day),
                                            SevenDayCalendar(day: day),
                                            AuraScoreIndicator(
                                              score: score,
                                              day: day,
                                              onTap: () => _onItemTapped(1)
                                            ),
                                            SizedBox(height: 30,),
                                            FindSolutions(),
                                          ],
                                        )));
                                      })
                                    ]))),
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

// text to display according to AuraScore
String getText(double score) {
  if (score < 2) {
    return "Low";
  } else if ((score >= 2) & (score < 4)) {
    return "Medium";
  } else if ((score >= 4) & (score < 6)) {
    return "High";
  } else {
    return "Your level is very high!";
  }
}

// to convert index values in DateTime
DateTime getDateForValue(int value) {
  DateTime now = DateTime.now();
  int difference = value - 3; // 3 is the central value and it represents today
  return now.add(Duration(days: difference));
}

// to draw semicircle for background
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
