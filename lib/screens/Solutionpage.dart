import 'package:flutter/material.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/models/SolutionCard.dart';
import 'package:aura/models/solution.dart';
import 'package:aura/screens/ElectroSolution.dart';
import 'package:aura/screens/MusicSolution.dart';

class Solutionpage extends StatelessWidget {
  // per debugging solutionPage
  bool needSleep = false;
  bool needExercise = false;
  bool isHot = false;

  List _fixedSolutionsTitles = ['Music','Elettroshock',];
  List _fixedSolutionsImages = ['assets/spotify.jpg', 'assets/electrodes.jpg'];
  final List<Widget> _fixedSolutionsPages = [MusicSolution(), ElectroSolution()];
  //List _optionaSolutions = optionalSolutions();

  Solutionpage(
      {super.key,
      required this.needSleep,
      required this.needExercise,
      required this.isHot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Solutions",
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
          itemCount: _fixedSolutionsTitles.length,
          itemBuilder: (BuildContext context, int index) {
            Solution solution = Solution(
              _fixedSolutionsTitles[index], 
              _fixedSolutionsImages[index],
              _fixedSolutionsPages[index]);
            return SolutionCard(solution: solution);
          }),
      ),
    );
  }
}
