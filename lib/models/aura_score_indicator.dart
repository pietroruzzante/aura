import 'package:aura/models/palette.dart';
import 'package:aura/models/work_sans.dart';
import 'package:aura/screens/Homepage.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:info_widget/info_widget.dart';

class AuraScoreIndicator extends StatelessWidget {
  final score;
  final day;
  final VoidCallback onTap;

  AuraScoreIndicator({
    required this.score,
    required this.day,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> _valueNotifier =
        ValueNotifier(score[day.toInt()]);

    return GestureDetector(
      onTap: onTap,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Container(
        width: 480,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Your Aura score:",
                    style: WorkSans.titleMedium,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DashedCircularProgressBar.aspectRatio(
                    aspectRatio: 1.5,
                    valueNotifier: _valueNotifier,
                    progress: score[day.toInt()],
                    maxProgress: 8,
                    startAngle: 225,
                    sweepAngle: 270,
                    foregroundColor: Palette.deepBlue,
                    backgroundColor: Palette.softBlue1,
                    foregroundStrokeWidth: 15,
                    backgroundStrokeWidth: 15,
                    animation: true,
                    animationDuration: Duration(milliseconds: 500),
                    animationCurve: Easing.standardDecelerate,
                    seekSize: 10,
                    seekColor: Palette.white,
                    child: Center(
                      child: ValueListenableBuilder(
                        valueListenable: _valueNotifier,
                        builder: (_, double value, __) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${value.toInt()}/8',
                              style: WorkSans.displayMedium
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(getText(score[day.toInt()]),
                                style: WorkSans.titleMedium
                                    .copyWith(fontWeight: FontWeight.w300)),
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
                      WorkSans.bodyMedium.copyWith(color: Palette.deepBlue),
                  iconData: Icons.info,
                  iconColor: Palette.blue,
                ),
              ),
            ),
            // Arrows to control AuraScoreIndicator
            /*
            Positioned(
              left: 0,
              top: 200,
              child: IconButton(
                onPressed: day.decrementDay,
                icon: Icon(
                Icons.arrow_back_ios_new,
                size: 30,
                color: day.toInt() == 0 ? Palette.transparent : Palette.deepBlue,
              )
              ),
            ),
            Positioned(
              right: 0,
              top: 200,
              child: IconButton(
                onPressed: day.incrementDay,
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 30,
                  color: day.toInt() == 6 ? Palette.transparent : Palette.deepBlue,),
              ),
            )*/
          ],
        ),
      ),
    );
  }

// Changes displayed day according to horizontal swipe direction
  void _onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity != null) {
      if (details.primaryVelocity! < 0) {
        day.incrementDay();
      } else if (details.primaryVelocity! > 0) {
        day.decrementDay();
      }
    }
  }
}
