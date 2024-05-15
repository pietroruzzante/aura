import 'package:aura/screens/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final TextEditingController _capController = TextEditingController();
  bool _isLoading = false;

  void _submitCap() async {
    setState(() {
      _isLoading = true;
    });

    String cap = _capController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('address', cap);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onboarding'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter your CAP',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _capController,
                decoration: InputDecoration(
                  labelText: 'CAP',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              _isLoading ? CircularProgressIndicator() : ElevatedButton(
                onPressed: _submitCap,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
