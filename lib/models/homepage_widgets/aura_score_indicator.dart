// import 'package:aura/models/palette.dart';
// import 'package:aura/models/homepage_widgets/today_date.dart';
// import 'package:aura/models/work_sans.dart';
// import 'package:aura/screens/Homepage.dart';
// import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:info_widget/info_widget.dart';

// class AuraScoreIndicator extends StatefulWidget {
//   final dynamic score;
//   final dynamic day;
//   final VoidCallback onTap;

//   AuraScoreIndicator({super.key, 
//     required this.score,
//     required this.day,
//     required this.onTap,
//   });

//   @override
//   State<AuraScoreIndicator> createState() => _AuraScoreIndicatorState();
// }

// class _AuraScoreIndicatorState extends State<AuraScoreIndicator> {
//   @override
//   Widget build(BuildContext context) {
//     final ValueNotifier<double> valueNotifier =
//         ValueNotifier(widget.score[widget.day.toInt()]);

//     return GestureDetector(
//       onTap: widget.onTap,
//       onHorizontalDragEnd: _onHorizontalDragEnd,
//       child: Container(
//         width: 480,
//         decoration: BoxDecoration(
//           boxShadow: const [
//             BoxShadow(
//               color: Palette.softBlue2,
//               blurRadius: 10,
//             ),
//           ],
//           color: Palette.white,
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//         child: Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   //TodayDate(day: widget.day),
//                   const SizedBox(height: 20,),
//                   DashedCircularProgressBar.aspectRatio(
//                     aspectRatio: 1.5,
//                     valueNotifier: valueNotifier,
//                     progress: widget.score[widget.day.toInt()],
//                     maxProgress: 10,
//                     startAngle: 225,
//                     sweepAngle: 270,
//                     foregroundColor: Palette.deepBlue,
//                     backgroundColor: Palette.softBlue1,
//                     foregroundStrokeWidth: 15,
//                     backgroundStrokeWidth: 15,
//                     animation: true,
//                     animationDuration: Duration(milliseconds: 500),
//                     animationCurve: Easing.standardDecelerate,
//                     seekSize: 10,
//                     seekColor: Palette.white,
//                     child: Center(
//                       child: ValueListenableBuilder(
//                         valueListenable: valueNotifier,
//                         builder: (_, double value, __) => Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               '${value.toInt()}/10',
//                               style: WorkSans.displayMedium
//                                   .copyWith(fontWeight: FontWeight.bold),
//                             ),
//                             Text(getText(widget.score[widget.day.toInt()]),
//                                 style: WorkSans.headlineMedium),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Info pop-up
//             Positioned(
//               top: 10,
//               right: 10,
//               child: Transform.scale(
//                 scale: 1.3,
//                 child: InfoWidget(
//                   infoText:
//                       "The score for the upcoming days has been calculated using today's stress score and future weather forecasts.",
//                   infoTextStyle:
//                       WorkSans.bodyMedium.copyWith(color: Palette.deepBlue),
//                   iconData: Icons.info,
//                   iconColor: Palette.blue,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// // Changes displayed day according to horizontal swipe direction
//   void _onHorizontalDragEnd(DragEndDetails details) {
//     if (details.primaryVelocity != null) {
//       if (details.primaryVelocity! < 0) {
//         widget.day.incrementDay();
//       } else if (details.primaryVelocity! > 0) {
//         widget.day.decrementDay();
//       }
//     }
//   }
// }


import 'package:aura/models/palette.dart';
import 'package:aura/models/homepage_widgets/today_date.dart';
import 'package:aura/models/work_sans.dart';
import 'package:aura/screens/Homepage.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:info_widget/info_widget.dart';

class AuraScoreIndicator extends StatefulWidget {
  final dynamic score;
  final dynamic day;
  final VoidCallback onTap;

  AuraScoreIndicator({
    super.key,
    required this.score,
    required this.day,
    required this.onTap,
  });

  @override
  State<AuraScoreIndicator> createState() => _AuraScoreIndicatorState();
}

class _AuraScoreIndicatorState extends State<AuraScoreIndicator> {
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> valueNotifier =
        ValueNotifier(widget.score[widget.day.toInt()]);

    return GestureDetector(
      onTap: widget.onTap,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Container(
        width: 480,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Palette.blue2, Palette.blue],
            begin: Alignment.topLeft,
            end: Alignment.center,
          ),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  DashedCircularProgressBar.aspectRatio(
                    aspectRatio: 1.5,
                    valueNotifier: valueNotifier,
                    progress: widget.score[widget.day.toInt()],
                    maxProgress: 10,
                    startAngle: 225,
                    sweepAngle: 270,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black12,
                    foregroundStrokeWidth: 15,
                    backgroundStrokeWidth: 15,
                    animation: true,
                    animationDuration: Duration(milliseconds: 500),
                    animationCurve: Curves.easeInOut,
                    seekSize: 10,
                    seekColor: Palette.white,
                    child: Center(
                      child: ValueListenableBuilder(
                        valueListenable: valueNotifier,
                        builder: (_, double value, __) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${value.toInt()}/10',
                              style: WorkSans.displayMedium
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            Text(
                              getText(widget.score[widget.day.toInt()]),
                              style: WorkSans.headlineMedium.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info pop-up
            Positioned(
              top: 10,
              right: 10,
              child: Transform.scale(
                scale: 1.3,
                child: InfoWidget(
                  infoText:
                      "The score for the upcoming days has been calculated using today's stress score and future weather forecasts.",
                  infoTextStyle:
                      WorkSans.bodyMedium.copyWith(color: Colors.white),
                  iconData: Icons.info_outline,
                  iconColor: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Changes displayed day according to horizontal swipe direction
  void _onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity != null) {
      if (details.primaryVelocity! < 0) {
        widget.day.incrementDay();
      } else if (details.primaryVelocity! > 0) {
        widget.day.decrementDay();
      }
    }
  }
}
