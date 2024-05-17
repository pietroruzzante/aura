import 'package:aura/screens/MichaelSol.dart';
import 'package:flutter/material.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/models/SolutionCard.dart';
import 'package:aura/models/solution.dart';
import 'package:aura/screens/BreathingSol.dart';
import 'package:aura/screens/SpotifySol.dart';

class Solutionpage extends StatelessWidget {
  // per debugging solutionPage
  bool needSleep = false;
  bool needExercise = false;
  bool isHot = false;

  List<Solution> _fixedSolutions = [
  Solution('Spotify', 'assets/spotify.png', SpotifySol()),
  Solution('Breathing', 'assets/breathing.png', BreathingSol()),
  Solution('Michael', 'assets/michaelsolution.png', MichaelSol()),
  ];

  //List _optionaSolutions = optionalSolutions();

  Solutionpage(
      {required this.needSleep,
      required this.needExercise,
      required this.isHot,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "What can you do?",
          style: Theme.of(context).textTheme.titleSmall
        ),
        titleTextStyle: TextStyle(
            color: Palette.blue,
            fontWeight: FontWeight.bold,
            fontSize: 20),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Palette.darkBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _fixedSolutions.length,
          itemBuilder: (BuildContext context, int index) {
            Solution solution = _fixedSolutions[index];
            return SolutionCard(solution: solution);
          }),
      ),
    );
  }
}
