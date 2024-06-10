import 'package:aura/models/palette.dart';
import 'package:aura/models/work_sans.dart';
import 'package:aura/screens/NoInternetpage.dart';
import 'package:aura/services/impact.dart';
import 'package:flutter/material.dart';
import 'package:aura/screens/Homepage.dart';
import 'package:aura/screens/Loginpage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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

  void _checkLogin(BuildContext context) async {
    final result = await Impact().refreshTokens();
    if (result == 200) {
      _toHomePage(context);
    } else {
      _toLoginPage(context);
    }
  }

  void _toNoInternetPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => NoInternetScreen())));
  }

  void _checkConnectionAndLogin(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    print('Connectivity Result: $connectivityResult');
    if (connectivityResult.contains(ConnectivityResult.none)) {
      _toNoInternetPage(context);
    } else {
      _checkLogin(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
        const Duration(seconds: 5), () => _checkConnectionAndLogin(context));
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Aura',
              style: WorkSans.displayMedium.copyWith(
                  color: Palette.darkBlue, fontWeight: FontWeight.bold),
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


