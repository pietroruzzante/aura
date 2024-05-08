import 'package:flutter/material.dart';
import 'package:stress/models/palette.dart';
import 'package:stress/models/solution_card_builder.dart';

class Solutionpage extends StatelessWidget {
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
        child: //SolutionsListBuilder()
        ListView(
          children: [
            SolutionCard(),
            SolutionCard(),
            SolutionCard(),
            SolutionCard(),
            SolutionCard(),
          ],
        ),
      ),
    );
  }
}

/*
class SolutionsListBuilder extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 200,
            child: Card(
              margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              color: Palette.blue,
              elevation: 5,
              shadowColor: Palette.darkBlue,
            ),
          );
        }
      ),
    );
  }
}
*/