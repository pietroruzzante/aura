import 'package:flutter/material.dart';
import 'package:aura/models/palette.dart';
import 'dart:async';

class BreathingSol extends StatefulWidget {
  const BreathingSol({super.key});

  @override
  State<BreathingSol> createState() => _BreathingSolState();
}

class _BreathingSolState extends State<BreathingSol> {
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
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Palette.white),
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
                        child: Text('Try other solutions'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: _isCycleActive
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: _stopCycle,
                    child: Text('Stop Breathing Exercise'),
                  ),
                )
              : SizedBox(),
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

  @override
  void initState() {
    super.initState();
    _startCycle();
  }

  void _startCycle() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentStateIndex < _phases.length) {
        setState(() {
          if (_timer != null) {
            if (_timer!.tick == _durations[_currentStateIndex].inSeconds) {
              _currentStateIndex = (_currentStateIndex + 1) % _phases.length;
              _timer!.cancel(); // cancel the current timer
              _startCycle(); // start the next cycle with the new duration
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Center(
        child: Text(
          _phases[_currentStateIndex % _phases.length],
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      );
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
      return Container();
    }
  }
}
