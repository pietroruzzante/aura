import 'package:aura/models/work_sans.dart';
import 'package:flutter/material.dart';
import 'package:aura/models/palette.dart';
import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class BreathingSol extends StatelessWidget {
  const BreathingSol({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Take a deep breath',
          style: WorkSans.titleSmall,
        ),
        backgroundColor: Palette.white,
        iconTheme: const IconThemeData(color: Palette.deepBlue),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Palette.white),
          child: const BreathingPhases()),
    );
  }
}

class BreathingPhases extends StatefulWidget {
  const BreathingPhases({super.key});

  @override
  State<BreathingPhases> createState() => _BreathingSolState();
}

class _BreathingSolState extends State<BreathingPhases> {
  bool _isCycleActive = false;

  void _startCycle() {
    setState(() {
      _isCycleActive = true;
    });
  }

  void _stopCycle() {
    if (mounted) {
      setState(() {
        _isCycleActive = false;
      });
    }
  }

  @override
  void dispose() {
    _isCycleActive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 60,
            height: 300,
            decoration: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Palette.softBlue2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (!_isCycleActive)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Are you ready?',
                          style: WorkSans.titleMedium,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CircularCountDownTimer(
                          width: 200,
                          height: 200,
                          duration: 0,
                          initialDuration: 0,
                          fillColor: Palette.blue,
                          ringColor: Palette.softBlue1,
                          isTimerTextShown: false,
                          textStyle: WorkSans.titleLarge,
                          strokeCap: StrokeCap.round,
                          textFormat: CountdownTextFormat.S,
                          strokeWidth: 10,
                          autoStart: true,
                          isReverse: true,
                          onComplete: () {},
                        ),
                      ],
                    )
                  else
                    StateCycle(
                      onCycleEnd: () {
                        if (mounted) {
                          setState(() {
                            _isCycleActive = false;
                          });
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isCycleActive ? _stopCycle : _startCycle,
            child: Text(
              _isCycleActive
                  ? 'Stop Breathing Exercise'
                  : 'Start Breathing Exercise',
              style: WorkSans.titleSmall.copyWith(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class StateCycle extends StatefulWidget {
  final Function onCycleEnd;

  const StateCycle({super.key, required this.onCycleEnd});

  @override
  _StateCycleState createState() => _StateCycleState();
}

class _StateCycleState extends State<StateCycle> {
  int _currentStateIndex = 0;
  final List<String> _phases = ['Breathe In', 'Hold', 'Breathe Out'];
  final List<Duration> _durations = const [
    Duration(seconds: 4),
    Duration(seconds: 7),
    Duration(seconds: 8),
  ];

  Timer? _timer;
  final CountDownController _controller = CountDownController();

  @override
  void initState() {
    super.initState();
    _startCycle();
  }

  void _startCycle() {
    _controller.start();
    _timer = Timer(_durations[_currentStateIndex], _nextPhase);
  }

  void _nextPhase() {
    setState(() {
      _currentStateIndex = (_currentStateIndex + 1) % _phases.length;
    });
    _controller.restart(duration: _durations[_currentStateIndex].inSeconds);
    _startCycle();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          _phases[_currentStateIndex],
          style: WorkSans.titleMedium,
        ),
        const SizedBox(
          height: 20,
        ),
        CircularCountDownTimer(
          width: 200,
          height: 200,
          duration: _durations[_currentStateIndex].inSeconds,
          initialDuration: 0,
          controller: _controller,
          fillColor: Palette.blue,
          ringColor: Palette.softBlue1,
          isTimerTextShown: true,
          textStyle: WorkSans.titleLarge,
          strokeCap: StrokeCap.round,
          textFormat: CountdownTextFormat.S,
          strokeWidth: 10,
          autoStart: true,
          isReverse: true,
          onComplete: () {},
        ),
      ],
    );
  }
}
