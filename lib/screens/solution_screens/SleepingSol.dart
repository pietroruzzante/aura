import 'package:aura/models/homepage_widgets/headache_score.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/models/work_sans.dart';
import 'package:aura/screens/solution_screens/BreathingSol.dart';
import 'package:aura/screens/solution_screens/YogaSol.dart';
import 'package:aura/services/impact.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SleepingSol extends StatefulWidget {
  const SleepingSol({super.key});

  @override
  State<SleepingSol> createState() => _SleepingSolState();
}

class _SleepingSolState extends State<SleepingSol> {
  TimeOfDay? _bedtime;
  TimeOfDay? _wakeupTime;
  String _messageHead = 'Set a sleeping schedule';
  String _message =
      'Set the time you plan on going to bed or waking up (or both!), and get personalized tips to find a consistent sleep schedule.';
  int sleepNeeded = 8; // default
  Map<String, String> linkMap = {
    'Reading': 'https://dreamlittlestar.com/bedtime-stories-for-adults/',
    'Music':
        'https://open.spotify.com/playlist/2bz6wk2mbPgF9ZNXhLN4Ts?si=0fe7203fa4364f4e',
  };

  @override
  void initState() {
    super.initState();
    _loadSleepNeeded();
  }

  Future<void> _loadSleepNeeded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int age = int.parse(prefs.getString('age')!);
    setState(() {
      sleepNeeded = calculateSleepNeeded(age);
    });
  }

  Future<void> open(BuildContext context, String name) async {
    String? url = linkMap[name];
    if (url != null) {
      final Uri toLaunch = Uri.parse(url);
      if (!await launchUrl(toLaunch, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.white,
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Sleeping Scheduler',
              style: WorkSans.titleSmall,
            ),
            backgroundColor: Palette.white,
            iconTheme: const IconThemeData(color: Palette.deepBlue),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    color: Palette.white,
                    elevation: 10,
                    shadowColor: Palette.softBlue2,
                    child: Column(
                      children: [
                        Text(
                          _messageHead,
                          style: WorkSans.titleSmall.copyWith(color: Palette.blue, fontSize: 20),
                        ),
                        ListTile(
                            title: Text(
                              'Select bed time',
                              style: WorkSans.bodyLarge
                                  .copyWith(color: Palette.deepBlue),
                            ),
                            trailing: _bedtime != null
                                ? Text(_bedtime!.format(context),
                                    style: WorkSans.bodyLarge
                                        .copyWith(color: Palette.deepBlue))
                                : const Icon(Icons.bedtime,
                                    color: Palette.deepBlue),
                            onTap: () async {
                              TimeOfDay? selectedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (selectedTime != null) {
                                setState(() {
                                  _bedtime = selectedTime;
                                  _updateMessage();
                                });
                              }
                            }),
                        ListTile(
                          title: Text(
                            'Select wake-up time',
                            style: WorkSans.bodyLarge
                                .copyWith(color: Palette.deepBlue),
                          ),
                          trailing: _wakeupTime != null
                              ? Text(_wakeupTime!.format(context),
                                  style: WorkSans.bodyLarge
                                      .copyWith(color: Palette.deepBlue))
                              : const Icon(
                                  Icons.wb_sunny,
                                  color: Palette.deepBlue,
                                ),
                          onTap: () async {
                            TimeOfDay? selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (selectedTime != null) {
                              setState(() {
                                _wakeupTime = selectedTime;
                                _updateMessage();
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15,0,15,10),
                          child: Text(
                            _message,
                            style: WorkSans.bodyMedium
                                .copyWith(color: Palette.deepBlue),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    color: Palette.white,
                    elevation: 10,
                    shadowColor: Palette.softBlue2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Bedtime Rituals',
                            style: WorkSans.titleSmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            children: [
                              Text(
                                'Routine',
                                textAlign: TextAlign.start,
                                style: WorkSans.headlineSmall.copyWith(
                                    color: Palette.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          title: Text(
                            'Deep Breathing Exercise',
                            style: WorkSans.bodyMedium
                                .copyWith(color: Palette.deepBlue),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Palette.deepBlue,
                            size: 15,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BreathingSol()));
                          },
                        ),
                        ListTile(
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          title: Text(
                            'Light Stretching or Gentle Yoga',
                            style: WorkSans.bodyMedium
                                .copyWith(color: Palette.deepBlue),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Palette.deepBlue,
                            size: 15,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => YogaSol()));
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            children: [
                              Text(
                                'Activities',
                                textAlign: TextAlign.start,
                                style: WorkSans.headlineSmall.copyWith(
                                    color: Palette.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          title: Text(
                            'Read a book! Reading short stories at bedtime induces positive emotions',
                            style: WorkSans.bodyMedium
                                .copyWith(color: Palette.deepBlue),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Palette.deepBlue,
                            size: 15,
                          ),
                          onTap: () => open(context, 'Reading'),
                        ),
                        ListTile(
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          title: Text(
                            'Listen to calming music or nature sounds to induce relaxation',
                            style: WorkSans.bodyMedium
                                .copyWith(color: Palette.deepBlue),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Palette.deepBlue,
                            size: 15,
                          ),
                          onTap: () => open(context, 'Music'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            children: [
                              Text(
                                'Environment',
                                textAlign: TextAlign.start,
                                style: WorkSans.headlineSmall.copyWith(
                                    color: Palette.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          title: Text(
                            'Maintain a cool and comfortable temperature in your bedroom',
                            style: WorkSans.bodyMedium
                                .copyWith(color: Palette.deepBlue),
                          ),
                          trailing: const Icon(
                            Icons.device_thermostat,
                            color: Palette.deepBlue,
                            size: 20,
                          ),
                        ),
                        ListTile(
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          title: Text(
                            'Use blackout curtains and reduce noise for an ideal sleeping environment',
                            style: WorkSans.bodyMedium
                                .copyWith(color: Palette.deepBlue),
                          ),
                          trailing: const Icon(
                            Icons.volume_off_rounded,
                            color: Palette.deepBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            children: [
                              Text(
                                'Other advice',
                                textAlign: TextAlign.start,
                                style: WorkSans.headlineSmall.copyWith(
                                    color: Palette.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          title: Text(
                            'Avoid electronic devices at least an hour before bed to reduce exposure to blue light',
                            style: WorkSans.bodyMedium
                                .copyWith(color: Palette.deepBlue),
                          ),
                          trailing: const Icon(
                            Icons.phonelink_off_rounded,
                            color: Palette.deepBlue,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          )),
    );
  }

  void _updateMessage() {
    if (_bedtime != null && _wakeupTime != null) {
      Duration sleepDuration = _calculateSleepDuration(_bedtime!, _wakeupTime!);
      if (sleepDuration >= Duration(hours: sleepNeeded)) {
        _messageHead = 'Awesome!';
        _message =
            'With a bedtime at ${_bedtime!.format(context)} and wake-up time at ${_wakeupTime!.format(context)}, you\'ll get your $sleepNeeded hours of sleep.';
      } else {
        _messageHead = 'Hmm... ';
        _message =
            'With a bedtime at ${_bedtime!.format(context)} and wake-up time at ${_wakeupTime!.format(context)}, you\'ll get less than $sleepNeeded hours of sleep. Consider adjusting your times.';
      }
    } else if (_bedtime != null) {
      TimeOfDay wakeupTime = _bedtime!.replacing(
          hour: (_bedtime!.hour + sleepNeeded) % 24, minute: _bedtime!.minute);
      _messageHead = 'Great choice!';
      _message =
          'If you go to bed at ${_bedtime!.format(context)}, you should wake up at ${wakeupTime.format(context)} to get your $sleepNeeded hours of sleep.';
    } else if (_wakeupTime != null) {
      TimeOfDay bedtime = _wakeupTime!.replacing(
          hour: (_wakeupTime!.hour - sleepNeeded + 24) % 24,
          minute: _wakeupTime!.minute);
      _messageHead = 'Great choice!';
      _message =
          'Rise and shine at ${_wakeupTime!.format(context)}! To get your $sleepNeeded hours of sleep, make sure to hit the bed by ${bedtime.format(context)}.';
    } else {
      _messageHead = 'Set a sleeping schedule';
      _message =
          'Set the time you plan on going to bed or waking up (or both!), and get personalized tips to find a consistent sleep schedule.';
    }
  }

  Duration _calculateSleepDuration(TimeOfDay bedtime, TimeOfDay wakeupTime) {
    int bedtimeMinutes = bedtime.hour * 60 + bedtime.minute;
    int wakeupMinutes = wakeupTime.hour * 60 + wakeupTime.minute;
    if (wakeupMinutes < bedtimeMinutes) {
      wakeupMinutes += 24 * 60;
    }
    return Duration(minutes: wakeupMinutes - bedtimeMinutes);
  }

  int calculateSleepNeeded(int age) {
    if (age <= 12) {
      return 9;
    } else if (age >= 13 && age <= 18) {
      return 8;
    } else {
      return 7;
    }
  }

  Future<List<dynamic>> loadData(BuildContext context) async {
    final impact = Impact();
    final todaySleep = await impact.getTodaySleep();
    final todayStress = await HeadacheScore().getStress();
    final todayWeather = await HeadacheScore().getWeather();
    final lastDateExercise = await impact.getLastExerciseDate();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final day0 = prefs.getDouble('day0');
    final day1 = prefs.getDouble('day1');
    final day2 = prefs.getDouble('day2');
    final age = int.parse(prefs.getString('age')!);
    final score = List.generate(todayWeather.length,
        (index) => todayWeather[index] + todayStress[index]);

    if (todaySleep == 0 || lastDateExercise == 'Not available data') {
      _showErrorToast(context);
    }
    return [
      todaySleep,
      todayStress,
      todayWeather,
      lastDateExercise,
      score,
      day0,
      day1,
      day2,
      age
    ];
  }
}

void _showErrorToast(BuildContext context) {
  CherryToast.warning(
    height: 100,
    width: 400,
    title: const Text(
      'Warning!',
      style: WorkSans.titleSmall,
    ),
    description: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Some data are not available',
            style: WorkSans.headlineSmall.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
      textAlign: TextAlign.left,
    ),
    displayIcon: true,
    animationType: AnimationType.fromTop,
    animationDuration: const Duration(seconds: 1),
    toastDuration: const Duration(seconds: 5),
    inheritThemeColors: true,
    autoDismiss: true,
  ).show(context);
}
