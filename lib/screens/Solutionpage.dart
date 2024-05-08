import 'package:flutter/material.dart';
import 'package:stress/models/palette.dart';
import 'package:stress/models/SolutionCard.dart';
import 'package:stress/models/solution.dart';

class Solutionpage extends StatelessWidget {
  final bool needSleep;
  final bool needExercise;
  final bool isHot;
  List _fixedSolutionsTitles = ['Music','Elettroshock',];
  List _fixedSolutionsImages = ['assets/music.jpg', 'assets/electrodes.jpg'];
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
            color: const Color.fromARGB(255, 24, 77, 142),
            fontWeight: FontWeight.bold,
            fontSize: 20),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _fixedSolutionsTitles.length,
          itemBuilder: (BuildContext context, int index) {
            Solution solution = Solution(_fixedSolutionsTitles[index], _fixedSolutionsImages[index]);
            return SolutionCard(solution: solution);
          }),
      ),
    );
  }
}
