import 'package:aura/screens/Accountscreen.dart';
import 'package:flutter/material.dart';
import 'package:aura/models/day.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aura/models/headache_score.dart';
import 'package:aura/screens/Loginpage.dart';
import 'package:aura/screens/Solutionpage.dart';
import 'package:aura/models/palette.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int index = 0;
  final score = HeadacheScore().refreshScore();
  final day = Day(); 

  void _onItemTapped(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  List<BottomNavigationBarItem> navBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.health_and_safety),
      label: 'Headache',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Settings',
    ),
  ];

  Widget _selectPage(int index, HeadacheScore score, Day day) {
    switch (index) {
      case 0:
        return DailyScore(score: score, day: day);
      case 1:
        return AccountScreen();
      default:
        return DailyScore(score: score, day: day);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Aura score",
        ),
        titleTextStyle: TextStyle(
          color: Palette.blue,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('login'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFf5f7f7),
        items: navBarItems,
        currentIndex: index,
        onTap: (index) => _onItemTapped(index),
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
                return Text('Error: ${snapshot.error}');
              }
              final HeadacheScore score = snapshot.data!;
              return _selectPage(index, score, day);
            }));

  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}



class DailyScore extends StatelessWidget {
  final HeadacheScore score;
  final Day day;

  DailyScore({
    required this.score,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child:
    SizedBox(
      width: 350,
      child:
    Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:
      [Text(
        "Welcome, user",
        style: TextStyle(
            color: Palette.blue, fontWeight: FontWeight.w500, fontSize: 20),
      )]),
      Consumer<Day>(builder: (context, day, child) {
        return Center(
            child: FittedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DayArrows(
                        incrementDay: day.incrementDay,
                        decrementDay: day.decrementDay,
                        day: day),
                    SevenDayCalendar(day: day),
                    MyGaugeIndicator(score: score, day: day),
                    solutionsHomepage(),
                  ],
                )));
      })
    ])));
  }
}

class SevenDayCalendar extends StatelessWidget {
  final day;

  SevenDayCalendar({required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 180,
        width: 500,
        child: EasyInfiniteDateTimeLine(
          firstDate: DateTime.now().subtract(Duration(days: 3)),
          focusDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 3)),
          timeLineProps: EasyTimeLineProps(separatorPadding: 1.0, margin: EdgeInsets.zero),
          dayProps: EasyDayProps(),
          showTimelineHeader: false,
          onDateChange: (selectedDate) => day.setDay(selectedDate, DateTime.now().subtract(Duration(days: 4)))
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
    return Container(
        width: 450,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          if (day > 0)
            IconButton(
                onPressed: decrementDay,
                icon: Icon(Icons.arrow_back_ios_new, size: 30)),
          SizedBox(width: 200),
          if (day < 6)
            IconButton(
                onPressed: incrementDay,
                icon: Icon(Icons.arrow_forward_ios, size: 30)),
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
          Text("What can you do?",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Palette.blue)),
          ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Solutionpage()));
              },
              label: Text(
                "Solutions",
                textScaler: TextScaler.linear(1.7),
              ))
        ],
      ),
      height: 150,
      width: 450,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20.0), // Applies same radius to all corners
      ),
    );
  }
}

class MyGaugeIndicator extends StatelessWidget {
  final score;
  final day;

  MyGaugeIndicator({required this.score, required this.day});

  Widget build(BuildContext context) {
    return Container(
        height: 400,
        width: 450,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            "Your Aura score:",
            style: TextStyle(
                color: Palette.blue, fontWeight: FontWeight.w700, fontSize: 20),
          ),
      Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnimatedRadialGauge(
                  duration: const Duration(seconds: 1),
                  curve: Curves.elasticOut,
                  radius: 200,
                  value: score[day.toInt()],
                  // ignore: prefer_const_constructors
                  axis: GaugeAxis(
                    min: 0,
                    max: 8,
                    degrees: 180,
                    style: const GaugeAxisStyle(
                      thickness: 30,
                      background: Color(0xFFDFE2EC),
                      segmentSpacing: 4,
                    ),
                    pointer: const GaugePointer.triangle(
                      height: 25,
                      width: 25,
                      borderRadius: 3,
                      color: Color(0xFF193663),
                      position:
                          GaugePointerPosition.surface(offset: Offset(5, 15)),
                    ),
                    // ignore: prefer_const_constructors
                    progressBar: const GaugeProgressBar.rounded(
                        color: Palette.lightBlue4),
                  ),
                ),
                Text('${score[day.toInt()].toInt()}/8',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Palette.blue,
                    )),
                Text(
                  getText(score[day.toInt()]),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Palette.blue,
                  ),
                ),
              ],
            )
        ]));
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
