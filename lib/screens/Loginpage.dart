
import 'package:aura/screens/CAP_onboarding.dart';
import 'package:aura/services/impact.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aura/models/palette.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Impact impact = Impact();
  bool _isLoading = false;
  String _errorMessage = '';
  bool _passwordVisible = false;

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Clear any previous error message
    });
    
    // Directly check if the email and password are not empty
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      try {
        final result = await impact.getAndStoreTokens(
            _emailController.text, _passwordController.text);
        if (result == 200) { // The credentials are correct, navigate to the Homepage
          final sp = await SharedPreferences.getInstance();
          await sp.setString('username', _emailController.text);
          await sp.setString('password', _passwordController.text);
          //await impact.getPatient();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => OnboardingPage()));
        } else {
          // The credentials are incorrect, show an error message
          setState(() {
            _errorMessage = 'Incorrect username or password';
            _isLoading = false;
          });
        }
      } catch (e) {
        // An exception occurred, show an error message
        setState(() {
          _errorMessage = 'An error occurred during login: $e';
          _isLoading = false;
        });
      }
    } else {
      // Email or password fields are empty, show an error message
      setState(() {
        _errorMessage = 'Please enter both username and password';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Palette.white,
            Palette.blue,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _icon(),
              const SizedBox(height: 50),
              _inputField("Username", _emailController),
              const SizedBox(height: 20),
              _inputField("Password", _passwordController, isPassword: true),
              const SizedBox(height: 10),
              _errorMessage.isNotEmpty
                  ? Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    )
                  : SizedBox(), // Show error message if not empty
              const SizedBox(height: 40),
              _isLoading ? CircularProgressIndicator() : _loginBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _icon() {
    return Image.asset(
      'assets/logo.png',
      height: 200,
      width: 200,
    );
  }

  Widget _inputField(String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        controller: controller,
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: TextStyle(color: Colors.white, fontSize: 15),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          prefixIcon: hintText == "Email"
              ? const Icon(Icons.email, color: Colors.white)
              : const Icon(Icons.lock, color: Colors.white),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                )
              : null,
        ),
        obscureText: isPassword ? !_passwordVisible : false,
      ),
    );
  }

  Widget _loginBtn() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: TextButton(
        onPressed: _login,
        child: const Text(
          "Login",
          style: TextStyle(
            fontSize: 20,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
