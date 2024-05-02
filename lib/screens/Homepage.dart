import 'package:flutter/material.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';
import 'package:provider/provider.dart';
import 'package:stress/models/headache_score.dart';
import 'package:stress/screens/Solutionpage.dart';


class Homepage extends StatelessWidget {

  final headScore = HeadacheScore().refreshScore();
  
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
          child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
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
                          progress: (headScore.getScore(3))/8,
                          color: Color.fromARGB(255, 243, 122, 49),
                          bottomPadding: -20,
                          contain: true,
                          child: Text(
                            "${headScore.getScore(3).toInt()}/8",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: Color.fromARGB(255, 243, 122, 49))),
                        );
                      }, // builder
                    ),
                    Text(
                      "Your stress level is very high!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white)
                    ),
                  ],
                )
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Headache forecast:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color.fromARGB(255, 231, 225, 220))
                    ),
                  ],
                ),
                height: 50,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0), // Applies same radius to all corners
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("What can you do?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromARGB(255, 231, 225, 220))
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Solutionpage()));
                      }, 
                      label: Text("Press and find some solutions")
                    )
                  ],
                ),
                height: 150,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0), // Applies same radius to all corners
                ),
              ),
            ],
          )
          )
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety), label: 'Headache '),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Settings'),
        ]
      ),
    );
  }
}
