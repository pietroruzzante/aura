import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stress/screens/Homepage.dart';
import 'package:stress/screens/Loginpage.dart';

class Splash extends StatelessWidget {
  static const route = '/splash/';
  static const routeDisplayName = 'SplashPage';

  const Splash({Key? key}) : super(key: key);

  // Method for navigation SplashPage -> HomePage
  void _toHomePage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: ((context) => Homepage())));
  } //_toHomePage

  void _toLoginPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => LoginPage())));
  } //_toHomePage

  void _checkAuth(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  if (isLoggedIn) {
    _toHomePage(context);
  } else {
    _toLoginPage(context);
  }
}

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () => _checkAuth(context));
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No Stress',
              style: TextStyle(
                  color: Color.fromARGB(255, 228, 175, 41),
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            Image.asset(
              'assets/app_logo_nuvolafulmine.jpg',
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}
