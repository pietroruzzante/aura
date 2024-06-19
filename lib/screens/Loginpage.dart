import 'package:aura/models/work_sans.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aura/services/impact.dart';
import 'package:aura/screens/Onboarding.dart';
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
      _errorMessage = '';
    });

    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      try {
        final result = await impact.getAndStoreTokens(
            _emailController.text, _passwordController.text);
        if (result == 200) {
          final sp = await SharedPreferences.getInstance();
          await sp.setString('username', _emailController.text);
          await sp.setString('password', _passwordController.text);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => OnboardingPage()));
        } else {
          setState(() {
            _errorMessage = 'Incorrect username or password';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred during login: $e';
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Please enter both username and password';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _page(),
    );
  }

  Widget _page() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _icon(),
            SizedBox(height: 50),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Insert your credentials ', style: WorkSans.displaySmall.copyWith(fontSize: 20),),
                const SizedBox(height: 40),
                _inputField("Username", _emailController),
                const SizedBox(height: 20),
                _inputField("Password", _passwordController, isPassword: true),
                const SizedBox(height: 10),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 40),
                _isLoading ? CircularProgressIndicator() : _loginBtn(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _icon() {
    return Image.asset(
      'assets/logo.png',
      height: 150,
      width: 150,
    );
  }

  Widget _inputField(String hintText, TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      style: WorkSans.headlineSmall,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: hintText == "Username" 
            ? Icon(Icons.email) 
            : Icon(Icons.lock),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
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
    );
  }

  Widget _loginBtn() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.deepBlue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          "Login",
          style: WorkSans.headlineMedium.copyWith(fontWeight: FontWeight.w400, color: Palette.white),
        ),
      ),
    );
  }
}

