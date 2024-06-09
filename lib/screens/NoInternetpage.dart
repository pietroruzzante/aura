import 'package:aura/models/palette.dart';
import 'package:aura/screens/Splash.dart';
import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.white,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.close,
                size: 100,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                'No internet connection detected. Please check your connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Restart the application
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: ((context) => Splash())));
                },
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
