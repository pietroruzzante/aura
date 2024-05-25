import 'package:aura/models/palette.dart';
import 'package:aura/models/work_sans.dart';
import 'package:flutter/material.dart';

class SleepingSol extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.white,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Sleep',
            style: WorkSans.titleSmall.copyWith(color: Palette.white),
          ),
        ),
        body: Center(
          child: Text(
            'Sleep',
            style: WorkSans.bodyMedium.copyWith(color: Palette.blue),),
        ),
      ),
    );
  }
}