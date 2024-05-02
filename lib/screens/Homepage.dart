import 'package:flutter/material.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stress/models/headache_score.dart';
import 'package:stress/screens/Loginpage.dart';
import 'package:stress/screens/Solutionpage.dart';

class Homepage extends StatelessWidget {
  
  final headScore = HeadacheScore().refreshScore();
  
  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Stress level",
        ),
        titleTextStyle: TextStyle(
            color: const Color.fromARGB(255, 24, 77, 142),
            fontWeight: FontWeight.bold,
            fontSize: 20),
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: FittedBox(
            child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DayButtonWidget(currentDate: DateTime.now()),
                circularHeadache(),
                headacheForecast(),
                solutionsHomepage(),
              ],
            )
          )
        ))
      ),
            drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('login_flow'),
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
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety), label: 'Headache '),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Settings'),
        ]
      )
    );
  }
}

class DayButtonWidget extends StatefulWidget {
  final DateTime currentDate;

  const DayButtonWidget({Key? key, required this.currentDate})
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
              style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getButtonColor(i),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
              ),
            ),
          ],
        )
    ;
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
      selectedDay = DateTime(widget.currentDate.year, widget.currentDate.month, 0).day + day - subtract;
      return selectedDay;
    } else {
      return selectedDay;
    }
  }

  int _getNextDay(int day, int toAdd) {
    final lastDayOfMonth = DateTime(widget.currentDate.year, widget.currentDate.month + 1, 0).day; // Get number of days in current month
    int selectedDay = DateTime(widget.currentDate.year, widget.currentDate.month, day).day + toAdd;
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

  Color _getButtonColor(int index) {
    if (index == 3) {
      return Colors.blue; // Highlight current day
    } else if (index < 3) {
      return Colors.green; // Previous days
    } else {
      return Colors.green; // Next days
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
                  fontSize: 20,
                  color: Color.fromARGB(255, 231, 225, 220))),
          ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Solutionpage()));
              },
              label: Text("Press and find some solutions"))
        ],
      ),
      height: 150,
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20.0), // Applies same radius to all corners
      ),
    );
  }
}

class headacheForecast extends StatelessWidget {
  const headacheForecast({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Headache forecast:",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color.fromARGB(255, 231, 225, 220))),
        ],
      ),
      height: 50,
      width: 350,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(20.0), // Applies same radius to all corners
      ),
    );
  }
}

class circularHeadache extends StatelessWidget {
  const circularHeadache({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: 350,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Your headache score:",
              style: TextStyle(
                  color: Color.fromARGB(255, 243, 122, 49),
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            Consumer<HeadacheScore>(
              builder: (context, headScore, child) {
                return SemicircularIndicator(
                  strokeWidth: 20,
                  radius: 100,
                  progress: (headScore.getScore(3)) / 8,
                  color: Color.fromARGB(255, 243, 122, 49),
                  bottomPadding: -20,
                  contain: true,
                  child: Text("${headScore.getScore(3).toInt()}/8",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 243, 122, 49))),
                );
              }, // builder
            ),
            Text("Your stress level is very high!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white)),
          ],
        ));
  }
}



