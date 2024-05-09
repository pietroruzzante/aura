import 'package:flutter/material.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stress/models/headache_score.dart';
import 'package:stress/screens/Loginpage.dart';
import 'package:stress/screens/Solutionpage.dart';
import 'package:stress/models/palette.dart';

class Homepage extends StatelessWidget {
  final score = HeadacheScore().refreshScore();
  final day = 5; //set default day to the current day

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Aura score",
          ),
          titleTextStyle: TextStyle(
              color: Palette.blue, fontWeight: FontWeight.bold, fontSize: 20),
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
        bottomNavigationBar: BottomNavigationBar(items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.health_and_safety), label: 'Headache '),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Settings'),
        ]),
        body: FutureBuilder<List<double>>(
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
              final List<double> score = snapshot.data!;
              return DailyScore(score: score);
            }));
  }
}

class DailyScore extends StatefulWidget {
  final List<double> score;

  DailyScore({Key? key, required this.score}) : super(key: key);
  @override
  _DailyScoreState createState() => _DailyScoreState();
}

class _DailyScoreState extends State<DailyScore> {
  int day = 3;

  void incrementDay() {
    setState(() {
      if (day < 6) {
        day++;
      }
    });
  }

  void decrementDay() {
    setState(() {
      if (day > 0) {
        day--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FittedBox(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DayArrows(
            day: day, incrementDay: incrementDay, decrementDay: decrementDay),
        DayButtonWidget(currentDate: DateTime.now(), score: widget.score),
        circularHeadache(score: widget.score, day: day),
        solutionsHomepage(),
      ],
    )));
  }
}

class DayArrows extends StatelessWidget {
  final int day;
  final VoidCallback incrementDay;
  final VoidCallback decrementDay;

  DayArrows({
    required this.day,
    required this.incrementDay,
    required this.decrementDay,
  });

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
        ]
        )
        );
  }
}

class DayButtonWidget extends StatefulWidget {
  final DateTime currentDate;
  final List<double> score;

  const DayButtonWidget(
      {Key? key, required this.currentDate, required this.score})
      : super(key: key);

  @override
  State<DayButtonWidget> createState() => _DayButtonWidgetState();
}

class _DayButtonWidgetState extends State<DayButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final dayNumbers = _calculateDayNumbers();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < dayNumbers.length; i++)
          ElevatedButton(
            onPressed: () {},
            child: Text(
              dayNumbers[i].toString(),
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: getButtonColor(widget.score[i]),
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
            ),
          ),
      ],
    );
  }

  List<int> _calculateDayNumbers() {
    final dayNumbers = [
      _getPreviousDay(widget.currentDate.day, 3),
      _getPreviousDay(widget.currentDate.day, 2),
      _getPreviousDay(widget.currentDate.day, 1),
      widget.currentDate.day,
      _getNextDay(widget.currentDate.day, 1),
      _getNextDay(widget.currentDate.day, 2),
      _getNextDay(widget.currentDate.day, 3),
    ];
    return dayNumbers;
  }

  int _getPreviousDay(int day, int subtract) {
    int selectedDay = day - subtract;
    if (day - subtract <= 0) {
      /*    da controllare: come vengono gestiti i giorni di inizio gennaio?
      int previousMonth = widget.currentDate.month - 1;
      if (previousMonth < 1) {
        previousMonth = 12;
      }
      */
      selectedDay =
          DateTime(widget.currentDate.year, widget.currentDate.month, 0).day +
              day -
              subtract;
      return selectedDay;
    } else {
      return selectedDay;
    }
  }

  int _getNextDay(int day, int toAdd) {
    final lastDayOfMonth =
        DateTime(widget.currentDate.year, widget.currentDate.month + 1, 0)
            .day; // Get number of days in current month
    int selectedDay =
        DateTime(widget.currentDate.year, widget.currentDate.month, day).day +
            toAdd;
    if (selectedDay > lastDayOfMonth) {
      var nextMonth = widget.currentDate.month + 1;
      if (nextMonth > 12) {
        nextMonth = 1;
      }
      selectedDay = selectedDay - lastDayOfMonth;
      return selectedDay;
    } else {
      return selectedDay;
    }
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
                    MaterialPageRoute(builder: (context) => Solutionpage(needSleep: true, needExercise: true, isHot: false,)));
              },
              label: Text(
                "Solutions",
                textScaler: TextScaler.linear(1.7),
              ))
        ],
      ),
      height: 200,
      width: 450,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20.0), // Applies same radius to all corners
      ),
    );
  }
}

class circularHeadache extends StatefulWidget {
  final List<double> score;
  final int day; //set default day to the current day

  const circularHeadache({Key? key, required this.score, required this.day})
      : super(key: key);

  @override
  State<circularHeadache> createState() => circularHeadacheState();
}

class circularHeadacheState extends State<circularHeadache> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400,
        width: 450,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Your Aura score:",
              style: TextStyle(
                  color: Palette.blue,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            Consumer<HeadacheScore>(
              builder: (context, score, child) {
                return
                SemicircularIndicator(
                  strokeWidth: 30,
                  radius: 150,
                  progress: (widget.score[widget.day]) / 8,
                  color: Palette.blue,
                  bottomPadding: -20,
                  contain: true,
                  child: Text("${widget.score[widget.day].toInt()}/8",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Palette.blue)),
                );
              }, // builder
            ),
            Text(getText(widget.score[widget.day]),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Palette.blue)),
          ],
        ));
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
