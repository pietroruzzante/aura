import 'package:aura/models/palette.dart';
import 'package:aura/models/work_sans.dart';
import 'package:flutter/material.dart';

class SleepingSol extends StatefulWidget {
  const SleepingSol({super.key});

  @override
  State<SleepingSol> createState() => _SleepingSolState();
}

class _SleepingSolState extends State<SleepingSol> {
  TimeOfDay? _bedTime;
  TimeOfDay? _wakeUpTime;

  Future<void> _selectTime(BuildContext context, bool isBedTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isBedTime) {
          _bedTime = picked;
        } else {
          _wakeUpTime = picked;
        }
      });
    }
  }

  String _calculateSleepDuration() {
    if (_bedTime != null && _wakeUpTime != null) {
      int duration = calculateTimeDifference(_wakeUpTime!, _bedTime!);
      return 'You will get $duration hours of sleep.';
    } else if (_bedTime != null) {
      final int totalMinutes = _bedTime!.hour * 60 +
          _bedTime!.minute +
          8 * 60; // Converti l'orario di partenza in minuti totali da mezzanotte e aggiungi 8 ore
      int newHour = totalMinutes ~/ 60; // Estrai le ore
      int newMinute = totalMinutes % 60; // Estrai i minuti
      if (newHour >= 24) {
        newHour -= 24; // Sottrai 24 ore se l'orario supera le 24 ore
      }
      TimeOfDay suggestedWakeUpTime =
          TimeOfDay(hour: newHour, minute: newMinute);
      return 'If you go to bed at ${_bedTime!.format(context)}, wake up at ${suggestedWakeUpTime.format(context)} for enough sleep.';
    } else if (_wakeUpTime != null) {
      final suggestedBedTime =
          _wakeUpTime!.replacing(hour: _wakeUpTime!.hour - 8);
      return 'If you wake up at ${_wakeUpTime!.format(context)}, go to bed at ${suggestedBedTime.format(context)} for enough sleep.';
    } else {
      return 'Please set bed time or wake up time.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.white,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Set sleeping schedule',
            style: WorkSans.titleSmall,
          ),
          backgroundColor: Palette.white,
          iconTheme: const IconThemeData(color: Palette.deepBlue),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: Text(
                  _bedTime == null
                      ? 'Select Bed Time'
                      : 'Bed Time: ${_bedTime!.format(context)}',
                ),
                trailing: Icon(Icons.alarm),
                onTap: () => _selectTime(context, true),
              ),
              ListTile(
                title: Text(
                  _wakeUpTime == null
                      ? 'Select Wake Up Time'
                      : 'Wake Up Time: ${_wakeUpTime!.format(context)}',
                ),
                trailing: Icon(Icons.alarm),
                onTap: () => _selectTime(context, false),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final sleepMessage = _calculateSleepDuration();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(sleepMessage)),
                  );
                },
                child: Text('Calculate Sleep Duration'),
              ),
              SizedBox(height: 20),
              if (_bedTime != null && _wakeUpTime != null)
                ElevatedButton(
                  onPressed: () {
                    // Codice per impostare la sveglia
                  },
                  child: Text('Set Alarm'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

int calculateTimeDifference(TimeOfDay time1, TimeOfDay time2) {
  int time1InMinutes = time1.hour * 60 + time1.minute;
  int time2InMinutes = time1.hour * 60 + time1.minute;
  return (time2InMinutes - time1InMinutes).abs();
}
