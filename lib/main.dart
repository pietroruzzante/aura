import 'package:flutter/material.dart';
import 'package:aura/models/day.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/screens/Splash.dart';
import 'package:provider/provider.dart';


void main() {
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
          textTheme: TextTheme(
            displayMedium: TextStyle(fontFamily: 'WorkSans', fontSize: 42, fontWeight: FontWeight.w300),
            titleLarge: TextStyle(fontFamily: 'WorkSans', fontSize: 34, fontWeight: FontWeight.bold),
            titleMedium: TextStyle(fontFamily: 'WorkSans', fontSize: 28, fontWeight: FontWeight.w300),
            titleSmall: TextStyle(fontFamily: 'WorkSans', fontSize: 22, fontWeight: FontWeight.w300),
            headlineMedium: TextStyle(fontFamily: 'WorkSans', fontSize: 20, fontWeight: FontWeight.normal),
            bodyMedium: TextStyle(fontFamily: 'WorkSans', fontSize: 13, fontWeight: FontWeight.normal),
            labelMedium: TextStyle(fontFamily: 'WorkSans', fontSize: 10, fontWeight: FontWeight.normal),
          ),
          colorScheme:
              ColorScheme.fromSeed(seedColor: Palette.blue),
          useMaterial3: true,
          
        ),
        home:  Splash()
      )
    );
  }
}



