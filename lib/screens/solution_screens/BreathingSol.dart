import 'package:aura/models/work_sans.dart';
import 'package:flutter/material.dart';
import 'package:aura/models/palette.dart';
import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class BreathingSol extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Take a deep breath',
          style: WorkSans.titleSmall.copyWith(color: Palette.white),
        ),
      ),
      body: BreathingPhases(),
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
    setState(() {
      _isCycleActive = false;
    });
  }

  @override
  void dispose() {
    if (_isCycleActive) {
      _stopCycle();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: Duration(seconds: 1),
          color: Palette.white,
          child: Center(
            child: _isCycleActive
                ? StateCycle(
                    onCycleEnd: () {
                      setState(() {
                        _isCycleActive = false;
                      });
                    },
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        color: Palette.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'The 4-7-8 breathing technique is a method that can help reduce anxiety and improve sleep. It involves breathing in for four seconds, holding your breath for seven seconds, and then exhaling for eight seconds. This technique helps to slow down your breathing and encourages your body to enter a state of deep relaxation.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Palette.white),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _startCycle,
                        child: Text('Start Breathing Exercise'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        child: Text('Other solutions'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _isCycleActive
              ? Padding(
                padding: EdgeInsets.only(bottom: 150),
                child: ElevatedButton(
                  onPressed: _stopCycle,
                  child: Text('Stop Breathing Exercise',
                  style: WorkSans.titleSmall,),
                ),
              )
              : SizedBox(height: 200,),
        ),
      ],
    );
  }
}


class StateCycle extends StatefulWidget {
  final Function onCycleEnd;

  const StateCycle({Key? key, required this.onCycleEnd}) : super(key: key);

  @override
  _StateCycleState createState() => _StateCycleState();
}

class _StateCycleState extends State<StateCycle> {
  int _currentStateIndex = 0;
  List<String> _phases = ['Breathe In', 'Hold', 'Breathe Out'];
  List<Duration> _durations = [
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 40,),
          Text(
            _phases[_currentStateIndex],
            style: WorkSans.titleLarge,
          ),
          SizedBox(height: 40,),
          CircularCountDownTimer(
            width: 300,
            height: 300,
            duration: _durations[_currentStateIndex].inSeconds,
            initialDuration: 0,
            controller: _controller,
            fillColor: Palette.deepBlue,
            ringColor: Palette.softBlue1,
            isTimerTextShown: true,
            textStyle: WorkSans.titleLarge,
            strokeCap: StrokeCap.round,
            textFormat: CountdownTextFormat.S,
            strokeWidth: 15,
            autoStart: true, 
            onComplete: () {
            },
          ),
          SizedBox(
            height: 20,
          ),
          
        ],
      ),
    );
  }
}
