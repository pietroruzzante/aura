import 'package:flutter/material.dart';
import 'package:stress/models/palette.dart';
import 'package:stress/models/solution_card_builder.dart';

class Solutionpage extends StatelessWidget {
  final bool needSleep;
  final bool needExercise;
  final bool isHot;
  List _fixedSolutions = [
    'Music',
    'Elettroshock',
  ];

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
          itemCount: _fixedSolutions.length,
          itemBuilder: (BuildContext context, int index) {
            return SolutionCard(cardTitle: _fixedSolutions[index],);
          }),
      ),
    );
  }
}
