import 'package:aura/models/palette.dart';
import 'package:flutter/material.dart';
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
    return Container(
      color: Palette.white,
      child: _isCycleActive
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StateCycle(
                  onCycleEnd: () {
                    setState(() {
                      _isCycleActive = false;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _stopCycle,
                  child: Text('Stop Breathing Exercise'),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: Palette.darkBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Center(
                    child: Container(
                        child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'The 4-7-8 breathing technique is a method that can help reduce anxiety and improve sleep. It involves breathing in for four seconds, holding your breath for seven seconds, and then exhaling for eight seconds. This technique helps to slow down your breathing and encourages your body to enter a state of deep relaxation.',
                        style: TextStyle(color: Palette.white),
                        textAlign: TextAlign.justify,
                      ),
                    )),
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
            _timer!.cancel(); // Cancel the current timer
            _startCycle(); // Start the next cycle with the new duration
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
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            color: Palette.darkBlue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Center(
              child: Container(
                  child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  _phases[_currentStateIndex % _phases.length],
                  style: TextStyle(color: Palette.white),
                  textAlign: TextAlign.justify,
                ),
              )),
            ),
          )
        ],
      );
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
      return Container();
    }
  }
}
