
import 'package:aura/models/workSans.dart';
import 'package:flutter/material.dart';
import 'package:aura/models/day.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/screens/Splash.dart';
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
            displayLarge: WorkSans.displayLarge,
            displayMedium: WorkSans.displayMedium,
            displaySmall: WorkSans.displaySmall,
            titleLarge: WorkSans.titleLarge,
            titleMedium: WorkSans.titleMedium,
            titleSmall: WorkSans.titleSmall,
            headlineLarge: WorkSans.headlineLarge,
            headlineMedium: WorkSans.headlineMedium,
            headlineSmall: WorkSans.headlineSmall,
            bodyMedium: WorkSans.bodyMedium,
            labelMedium: WorkSans.labelMedium,
            ),
          colorScheme:
              ColorScheme.fromSeed(seedColor: Palette.blue),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            color: Palette.blue,
            iconTheme: IconThemeData(
              color: Palette.deepBlue,
            ),
            titleTextStyle: WorkSans.titleMedium?.copyWith(color: Palette.white),
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



