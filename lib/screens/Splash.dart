import 'package:aura/models/palette.dart';
import 'package:aura/models/work_sans.dart';
import 'package:aura/services/impact.dart';
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

/*
  void _checkAuth(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      _toHomePage(context);
    } else {
      _toLoginPage(context);
    }
  }
*/
 
  void _checkLogin(BuildContext context) async {
    final result = await Impact().refreshTokens();
    if (result == 200) {
      _toHomePage(context);
    } else {
      _toLoginPage(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () => _checkLogin(context));
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Aura',
              style: WorkSans.displayMedium.copyWith(color: Palette.darkBlue, fontWeight: FontWeight.bold),
            ),
            Image.asset(
              'assets/logo.png',
              height: 200,
              width: 200,
            ),
            SizedBox(height: 250),
            Text(
              'Powered by:',
              style: WorkSans.headlineMedium,
            ),
            Text(
              'DartVaders',
              style: WorkSans.headlineMedium,
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
