
import 'package:flutter/material.dart';
import 'package:aura/models/day.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/screens/Splash.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() {
  initializeDateFormatting('en_US', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Day>(
      create: (context) => Day(),
      child: MaterialApp(
        title: 'Aura',
        theme: ThemeData(
          scaffoldBackgroundColor: Palette.transparent,
          textTheme: TextTheme(
            displayLarge: TextStyle(fontFamily: 'WorkSans', fontSize: 50, fontWeight: FontWeight.w300, color: Palette.deepBlue),
            displayMedium: TextStyle(fontFamily: 'WorkSans', fontSize: 42, fontWeight: FontWeight.w300, color: Palette.deepBlue),
            displaySmall: TextStyle(fontFamily: 'WorkSans', fontSize: 34, fontWeight: FontWeight.w300, color: Palette.deepBlue),
            titleLarge: TextStyle(fontFamily: 'WorkSans', fontSize: 34, fontWeight: FontWeight.bold, color: Palette.deepBlue),
            titleMedium: TextStyle(fontFamily: 'WorkSans', fontSize: 28, fontWeight: FontWeight.bold, color: Palette.deepBlue),
            titleSmall: TextStyle(fontFamily: 'WorkSans', fontSize: 22, fontWeight: FontWeight.bold, color: Palette.deepBlue),
            headlineLarge: TextStyle(fontFamily: 'WorkSans', fontSize: 22, fontWeight: FontWeight.normal, color: Palette.deepBlue),
            headlineMedium: TextStyle(fontFamily: 'WorkSans', fontSize: 20, fontWeight: FontWeight.normal, color: Palette.deepBlue),
            headlineSmall: TextStyle(fontFamily: 'WorkSans', fontSize: 18, fontWeight: FontWeight.normal, color: Palette.deepBlue),
            bodyMedium: TextStyle(fontFamily: 'WorkSans', fontSize: 13, fontWeight: FontWeight.normal, color: Palette.white),
            labelMedium: TextStyle(fontFamily: 'WorkSans', fontSize: 10, fontWeight: FontWeight.normal, color: Palette.white),
          ),
          colorScheme:
              ColorScheme.fromSeed(seedColor: Palette.blue),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            color: Palette.transparent,
            iconTheme: IconThemeData(
              color: Palette.deepBlue,
            )
          ),
          actionIconTheme: ActionIconThemeData(
            backButtonIconBuilder: (context) => Icon(Icons.arrow_back_ios),
          )
        ),
        home:  Splash()
      )
    );
  }
}



