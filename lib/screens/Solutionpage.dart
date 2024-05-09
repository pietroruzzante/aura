import 'package:flutter/material.dart';
import 'package:stress/models/palette.dart';
import 'package:stress/models/SolutionCard.dart';
import 'package:stress/models/solution.dart';
import 'package:stress/screens/ElectroSolution.dart';
import 'package:stress/screens/MusicSolution.dart';

class Solutionpage extends StatelessWidget {
  // per debugging solutionPage
  bool needSleep = false;
  bool needExercise = false;
  bool isHot = false;

  List _fixedSolutionsTitles = ['Music','Elettroshock',];
  List _fixedSolutionsImages = ['assets/music.jpg', 'assets/electrodes.jpg'];
  List _fixedSolutionsRoutes = ['/MusicSolution', '/ElectrodesSolution'];
  final List<Widget> solutionPages = [MusicSolution(), ElectroSolution()];
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
            Solution solution = Solution(
              _fixedSolutionsTitles[index], 
              _fixedSolutionsImages[index],
              _fixedSolutionsRoutes[index]);
            return SolutionCard(solution: solution);
          }),
      ),
    );
  }
}
