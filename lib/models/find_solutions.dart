import 'package:aura/models/curved_background.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/models/work_sans.dart';
import 'package:aura/screens/Solutionpage.dart';
import 'package:flutter/material.dart';

class FindSolutions extends StatelessWidget {
  const FindSolutions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Solutionpage()));
      },
      child: Container(
          width: 480,
          height: 200,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Palette.softBlue2,
                blurRadius: 10,
              ),
            ],
            color: Palette.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: [
              Hero(
                tag: 'solution page',
                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipPath(
                      child: CurvedBackground(
                        height: MediaQuery.of(context).size.height * 0.25,
                        color: Palette.blue,),
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'SOLUTIONS',
                  style: WorkSans.headlineMedium,
                ),
              )
            ],
          )),
    );
  }
}