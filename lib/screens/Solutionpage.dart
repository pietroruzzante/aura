import 'package:aura/screens/solution_screens/MichaelSol.dart';
import 'package:flutter/material.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/models/solutionCard.dart';
import 'package:aura/models/solution.dart';
import 'package:aura/screens/solution_screens/BreathingSol.dart';
import 'package:aura/screens/solution_screens/SpotifySol.dart';

class Solutionpage extends StatelessWidget {
  bool needSleep = false;
  bool needExercise = false;

  List<Solution> _fixedSolutions = [
  Solution('Spotify', 'assets/spotify.png', SpotifySol()),
  Solution('Breathing', 'assets/breathing.png', BreathingSol()),
  Solution('Michael', 'assets/michaelsolution.png', MichaelSol()),
  ];

  List<Solution> _optionaSolutions = [
  ];

  Solutionpage(
      {required this.needSleep,
      required this.needExercise,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
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
            "What can you do?",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          /*
          titleTextStyle: TextStyle(
              color: Palette.blue,
              fontWeight: FontWeight.bold,
              fontSize: 20),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Palette.darkBlue),
            onPressed: () => Navigator.pop(context),
          ),
          */
        ),
        body: Center(
          child: ListView.builder(
            itemCount: _fixedSolutions.length,
            itemBuilder: (BuildContext context, int index) {
              Solution solution = _fixedSolutions[index];
              return SolutionCard(solution: solution);
            }),
        ),
      ),
    );
  }
}
