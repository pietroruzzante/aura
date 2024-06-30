
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aura/screens/Homepage.dart';
import 'package:aura/models/palette.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _selectedGender = 'man';
  bool _isLoading = false;
  String _errorMessage = '';

  void _submitZipCode() async {
    setState(() {
      _errorMessage = '';
    });

    String name = _nameController.text;
    String zip = _zipController.text;
    String age = _ageController.text;
    String gender = _selectedGender;

    // ZIP CODE VALIDATION
    if (zip.isEmpty) {
      setState(() {
        _errorMessage = 'ZIP code is necessary';
        _isLoading = false;
      });
      return;
    }

    if (zip.length != 5) {
      setState(() {
        _errorMessage = 'ZIP code must be 5 numbers';
        _isLoading = false;
      });
      return;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(zip)) {
      setState(() {
        _errorMessage = 'ZIP code must contain only numbers';
        _isLoading = false;
      });
      return;
    }

    // AGE VALIDATION
    if (age.isEmpty) {
      setState(() {
        _errorMessage = 'Age is necessary';
        _isLoading = false;
      });
      return;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(age)) {
      setState(() {
        _errorMessage = 'Age must contain only numbers';
        _isLoading = false;
      });
      return;
    }

    int ageValue = int.parse(age);
    if (ageValue < 0 || ageValue > 120) {
      setState(() {
        _errorMessage = 'Age must be between 0 and 120';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('zipCode', zip);
    await prefs.setString('age', age);
    await prefs.setString('gender', gender);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _icon(),
              SizedBox(height: 50),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter your Info',
                    style: TextStyle(fontSize: 24, fontFamily: 'WorkSans'),
                  ),
                  const SizedBox(height: 20),
                  _inputField('Name', _nameController),
                  const SizedBox(height: 20),
                  _inputField('ZIP code', _zipController, keyboardType: TextInputType.number),
                  const SizedBox(height: 20),
                  _inputField('Age', _ageController, keyboardType: TextInputType.number),
                  const SizedBox(height: 20),
                  _genderDropdown(),
                  const SizedBox(height: 20),
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator()
                      : _submitBtn(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Palette.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      keyboardType: keyboardType,
    );
  }

    Widget _icon() {
    return Image.asset(
      'assets/logo.png',
      height: 150,
      width: 150,
    );
  }

  Widget _genderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
        color: Palette.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue!;
            });
          },
          items: <String>['man', 'woman']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(fontFamily: 'WorkSans'),
              ),
            );
          }).toList(),
          isExpanded: true,
          dropdownColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _submitBtn() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitZipCode,
        child: Text(
          'Submit',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'WorkSans',
            color: Palette.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Palette.deepBlue, backgroundColor: Palette.deepBlue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
