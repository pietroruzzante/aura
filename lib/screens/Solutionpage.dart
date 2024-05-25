import 'package:aura/models/headache_score.dart';
import 'package:aura/models/work_sans.dart';
import 'package:aura/screens/solution_screens/MichaelSol.dart';
import 'package:aura/services/impact.dart';
import 'package:flutter/material.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/models/solutionCard.dart';
import 'package:aura/models/solution.dart';
import 'package:aura/screens/solution_screens/BreathingSol.dart';
import 'package:aura/screens/solution_screens/SpotifySol.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'solution_screens/ExerciseSol.dart';
import 'solution_screens/SleepingSol.dart';

class Solutionpage extends StatefulWidget {
  Solutionpage({super.key});

  @override
  State<StatefulWidget> createState() => _SolutionpageState();
}

class _SolutionpageState extends State<Solutionpage> {
  int age = 25;

  final _scrollController = ScrollController();

  List<Solution> _fixedSolutions = [
    Solution('Spotify', 'assets/spotify.png', SpotifySol()),
    Solution('Breathing', 'assets/breathing.png', BreathingSol()),
    Solution('Michael', 'assets/michaelsolution.png', MichaelSol()),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

/*
  Future<void> _loadAge() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      age = prefs.getInt('age') ?? 25; // Default age is 25 if not found
    });
  }
  */

  Future<List<dynamic>> _loadData() async {
    //await _loadAge();
    final impact = Impact();
    final todaySleep = await impact.getTodaySleep();
    final todayStress = await HeadacheScore().getStress();
    final todayWeather = await HeadacheScore().getWeather();
    final lastDateExercise = await impact.getLastExerciseDate();
    return [todaySleep, todayStress, todayWeather, lastDateExercise];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Palette.white,
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "What can you do?",
                style: WorkSans.titleSmall.copyWith(color: Palette.white),
              ),
            ),
            body: Stack(
              children: [
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
                Positioned.fill(
                  child: FutureBuilder<dynamic>(
                      future: _loadData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error');
                        } else {
                          final data = snapshot.data;
                          return ListView.builder(
                            controller: _scrollController,
                              itemCount: _getSolutions(data!).length,
                              itemBuilder: (BuildContext context, int index) {
                                Solution solution = _getSolutions(data)[index];
                                return SolutionCard(solution: solution);
                              });
                        }
                      }
                  ),
                ),
              ],
            )
            
            )
    );
  }

  List<Solution> _getSolutions(List<dynamic> data) {
    List<Solution> solutions = List.from(_fixedSolutions);
    if (needSleep(data[0])) {
      solutions.add(Solution('Sleeping', 'assets/spotify.png', SleepingSol()));
    }
    if (needExercise()) {
      solutions.add(Solution('Exercise', 'assets/spotify.png', ExerciseSol()));
    }
    return solutions;
  }

  bool needSleep(double todaySleep) {
    int sleepNeeded; 
    if (age<=12) {
      sleepNeeded = 9;
    } else if (age>=13 && age<=18) {
      sleepNeeded = 8;
    } else {
      sleepNeeded = 7;
    }
    return todaySleep < sleepNeeded;
  }

  bool needExercise() {
    return true;
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