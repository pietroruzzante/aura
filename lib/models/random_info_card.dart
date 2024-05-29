import 'package:aura/models/palette.dart';
import 'package:aura/models/random_info.dart';
import 'package:aura/models/work_sans.dart';
import 'package:flutter/material.dart';

class RandomInfoCard extends StatelessWidget {
  final RandomInfo migraineInfo;

  const RandomInfoCard({super.key, required this.migraineInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: Card(
        //semanticContainer: true,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
        color: Palette.white,
        elevation: 10,
        shadowColor: Palette.softBlue2,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(
                migraineInfo.infoTitle,
                style: WorkSans.headlineSmall.copyWith(fontSize: 20,),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10,),
              Text(
                migraineInfo.infoDescription,
                style: WorkSans.bodyMedium.copyWith(color: Palette.blue),
                textAlign: TextAlign.left,
              )
            ],)
          ),
        ),
      ),
    );
  }
}