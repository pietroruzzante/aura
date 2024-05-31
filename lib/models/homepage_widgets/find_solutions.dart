import 'package:aura/models/palette.dart';
import 'package:aura/screens/Solutionpage.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class FindSolutions extends StatefulWidget {

  FindSolutions({super.key});

  @override
  State<FindSolutions> createState() => _FindSolutionsState();
}

class _FindSolutionsState extends State<FindSolutions> with TickerProviderStateMixin {
  final String weatherAnimation = 'assets/weather_animation.gif';
  late GifController _controller;

  @override
  void initState() {
    _controller = GifController(vsync: this);
    super.initState();
  }

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
          boxShadow: const [
            BoxShadow(
              color: Palette.softBlue2,
              blurRadius: 10,
            ),
          ],
          color: Palette.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Gif(
            image: AssetImage(weatherAnimation),
            controller: _controller,
            fps: 30,
            autostart: Autostart.once,
            fit: BoxFit.fill,
            placeholder: (context) => Image.asset('assets/weather_animation_first_frame.png'),
          ),
        ),
      ),
    );
  }
}
