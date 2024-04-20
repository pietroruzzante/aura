import 'package:flutter/material.dart';

class Solutionpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Solution",
        ),
        titleTextStyle: TextStyle(
            color: const Color.fromARGB(255, 24, 77, 142),
            fontWeight: FontWeight.bold,
            fontSize: 20),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [Text("Here you can find some tips:")],
        ),
      ),
    );
  }
}
