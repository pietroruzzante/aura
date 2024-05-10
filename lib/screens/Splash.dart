import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aura/screens/Homepage.dart';
import 'package:aura/screens/Loginpage.dart';

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
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Aura',
              style: TextStyle(
                  color: Color.fromARGB(255, 6, 40, 73),
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            Image.asset(
              'assets/logo.png',
              height: 200,
              width: 200,
            ),
            SizedBox(height: 250),
            Text('Powered by:',
            style: TextStyle(
                  color: Color.fromARGB(255, 6, 40, 73),
                  fontSize: 15,
                  fontWeight: FontWeight.w400),),
            Text('DartVaders',
            style: TextStyle(
                  color: Color.fromARGB(255, 6, 40, 73),
                  fontSize: 15,
                  fontWeight: FontWeight.w400),),
            SizedBox(height: 50),

          ],
        ),
      ),
    );
  }
}
