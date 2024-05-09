import 'package:flutter/material.dart';

class ElectroSolution extends StatelessWidget {
  const ElectroSolution({super.key});

  static const routename = '/ElectroSolution';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ElectroSolution.routename),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('To the home'),
              onPressed: () {
                //This allows to get back to the HomePage
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
  
}