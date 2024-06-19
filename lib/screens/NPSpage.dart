import 'package:aura/models/work_sans.dart';
import 'package:aura/screens/Loginpage.dart';
import 'package:flutter/material.dart';
import 'package:aura/models/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NPSpage extends StatefulWidget {
  @override
  _NPSpageState createState() => _NPSpageState();
}

class _NPSpageState extends State<NPSpage> {
  double selectedScore = 5.0;

  IconData getIconForScore(int score) {
    if (score >= 0 && score <= 6) {
      return Icons.sentiment_dissatisfied_outlined; // Sad face icon
    } else if (score >= 7 && score <= 8) {
      return Icons.sentiment_neutral_outlined; // Neutral face icon
    } else if (score >= 9 && score <= 10) {
      return Icons.sentiment_satisfied_outlined; // Happy face icon
    } else {
      return Icons.sentiment_neutral_outlined; // Default to neutral face icon
    }
  }

  Color getColorForScore(int score) {
    if (score >= 0 && score <= 6) {
      return Colors.red; // Red for scores 0-6
    } else if (score >= 7 && score <= 8) {
      return Colors.orange; // Yellow for scores 7-8
    } else if (score >= 9 && score <= 10) {
      return Colors.green; // Green for scores 9-10
    } else {
      return Colors.black; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Palette.deepBlue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Image.asset(
                'assets/logo.png',
                height: 150,
                width: 150,
              ),
              SizedBox(height: 100),
              Text(
                'Are you sure?\nAll your data will be deleted',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'WorkSans',
                  color: Palette.deepBlue,
                ),
              ),
              SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showLogoutConfirmationDialog(context);
                  },
                  child: Text(
                    'Confirm Logout',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'WorkSans',
                      color: Palette.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Palette.deepBlue,
                    backgroundColor: Palette.deepBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'WorkSans',
                      color: Palette.deepBlue,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Palette.deepBlue,
                    backgroundColor: Palette.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.99,
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Please Rate Us!',
                      style: WorkSans.titleSmall,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'How likely would you recommend Aura to a friend or colleague?',
                      style: WorkSans.bodyMedium.copyWith(color: Palette.black),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          getIconForScore(selectedScore.toInt()),
                          size: 70,
                          color: getColorForScore(selectedScore.toInt()),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Slider(
                      value: selectedScore,
                      activeColor: getColorForScore(selectedScore.toInt()),
                      inactiveColor: Palette.softBlue1,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      label: selectedScore.toInt().toString(),
                      onChanged: (double value) {
                        setState(() {
                          selectedScore = value;
                        });
                      },
                      autofocus: true,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final sp = await SharedPreferences.getInstance();
                            await sp.clear();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: ((context) => LoginPage())));
                          },
                          child: Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Palette.white,
                            backgroundColor: Palette.deepBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
