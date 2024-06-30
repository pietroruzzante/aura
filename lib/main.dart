import 'package:aura/models/edit_account_widgets/user_model.dart';
import 'package:aura/models/work_sans.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Day>(create: (context) => Day()),
        ChangeNotifierProvider<UserModel>(create: (context) => UserModel()),
      ],
      child: MaterialApp(
        title: 'Aura',
        theme: ThemeData(
          scaffoldBackgroundColor: Palette.transparent,
          colorScheme: ColorScheme.fromSeed(seedColor: Palette.blue),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            color: Palette.white,
            iconTheme: IconThemeData(color: Palette.deepBlue),
            titleTextStyle: WorkSans.titleMedium.copyWith(color: Palette.deepBlue),
          ),
          actionIconTheme: ActionIconThemeData(
            backButtonIconBuilder: (context) => Icon(Icons.arrow_back_ios),
          ),
        ),
        home: Splash(),
      ),
    );
  }
}




