
import 'package:flutter/material.dart';
import 'package:aura/models/day.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/screens/Splash.dart';
import 'package:provider/provider.dart';


void main() async{
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
          colorScheme:
              ColorScheme.fromSeed(seedColor: Palette.blue),
          useMaterial3: true,
          
        ),
        home:  Splash()
      )
    );
  }
}



