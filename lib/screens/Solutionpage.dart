import 'dart:ffi';
import 'dart:math';

import 'package:aura/models/curved_background.dart';
import 'package:aura/models/headache_score.dart';
import 'package:aura/models/random_info.dart';
import 'package:aura/models/random_info_card.dart';
import 'package:aura/models/work_sans.dart';
import 'package:aura/screens/solution_screens/MichaelSol.dart';
import 'package:aura/services/impact.dart';
import 'package:flutter/material.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/models/solution_card.dart';
import 'package:aura/models/solution.dart';
import 'package:aura/screens/solution_screens/BreathingSol.dart';
import 'package:aura/screens/solution_screens/SpotifySol.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'solution_screens/ExerciseSol.dart';
import 'solution_screens/SleepingSol.dart';

class Solutionpage extends StatefulWidget {
  Solutionpage({super.key});

  @override
  State<StatefulWidget> createState() => _SolutionpageState();
}

class _SolutionpageState extends State<Solutionpage> {
  int age = 25;

  final List<Solution> _fixedSolutions = [
    Solution(
      'Spotify',
      'assets/spotify.png',
      'Dive into our specially curated Spotify playlist crafted to ease migraine symptoms and promote well-being. Take a break from tension and pain, and let the therapeutic power of music transport you. Discover how simple listening can make a difference in your personal relief.',
      pageRoute: SpotifySol()),
    Solution(
      'Breathing',
      'assets/breathing.png',
      'Experience a guided breathing exercise designed to ease migraine symptoms and promote relaxation. Allow your breath to soothe tension and bring relief, discover the calming effect of mindful breathing on your migraine journey.',
      pageRoute: BreathingSol()),
    Solution(
      'Michael',
      'assets/michaelsolution.png',
      'Join us in exploring this unexpected approach to easing stress, straight from the iconic sitcom. Discover how Michael\'s unique methods may just provide a humorous yet surprisingly effective way to tackle anxiety. Embrace the unexpected and let laughter be your guide on the path to relaxation.',
      pageRoute: MichaelSol()),
    //Solution('More coming', 'assets/more_coming.png')
  ];

  List<RandomInfo> _migraineInfoList = [
    RandomInfo('Migraines are a neurological disorder',
        'They can cause severe headaches, nausea, and sensitivity to light or sound.'),
    RandomInfo('There are different types of migraines',
        'There\'s migraine with aura, without aura, and chronic migraine, each with its own symptoms.'),
    RandomInfo('Migraine symptoms include throbbing pain',
        'Often accompanied by nausea and sensitivity to light and noise.'),
    RandomInfo('Certain foods can trigger migraines',
        'Chocolate, aged cheese, and alcohol are common culprits.'),
    RandomInfo('Stress and anxiety are common triggers',
        'Practicing relaxation techniques can make a big difference.'),
    RandomInfo('Hormonal imbalances can cause migraines',
        'Fluctuations during menstrual cycles, pregnancy, or menopause are often to blame.'),
    RandomInfo('Staying hydrated helps prevent migraines',
        'Drinking at least 8 glasses of water a day can be very beneficial.'),
    RandomInfo('Relaxation techniques like yoga and meditation help',
        'They can reduce stress and prevent migraine attacks.'),
    RandomInfo('Regular exercise can reduce migraines',
        'Staying physically active helps decrease the frequency and severity of attacks.'),
    RandomInfo('Identifying and avoiding personal triggers is key',
        'Avoiding certain foods or stressful situations can help prevent migraines.'),
    RandomInfo('Keeping a regular sleep routine makes a difference',
        'Getting enough sleep and keeping consistent sleep times helps reduce migraines.'),
    RandomInfo('Limiting caffeine can be helpful',
        'Caffeine can assist, but overdoing it can turn into a trigger.'),
    RandomInfo('About 25-30% of people with migraines experience an aura',
        'These visual or sensory disturbances can appear before the headache.'),
    RandomInfo('Migraines affect about 12% of the global population',
        'And women are more affected than men.'),
    RandomInfo('Migraines tend to be hereditary',
        'If one or both of your parents suffer from migraines, you\'re more likely to have them too.'),
    RandomInfo('Over-the-counter meds like ibuprofen or acetaminophen can help',
        'They can relieve migraine symptoms.'),
    RandomInfo(
        'Alternative therapies like acupuncture and biofeedback are valid options',
        'Supplements like magnesium and riboflavin can also help.'),
    RandomInfo('Applying a cold or hot pack to your head or neck helps',
        'It can reduce pain during a migraine attack.'),
    RandomInfo('Working with your doctor on a prevention plan is important',
        'Preventive medications and lifestyle changes can make a big difference.'),
    RandomInfo('Joining support groups can offer comfort',
        'Talking to others who suffer from migraines can provide useful tips.')
  ];

  RandomInfo? _randomMigraineInfo;

  @override
  void initState() {
    super.initState();
    _loadData();
    _setRandomMigraineInfo();
  }

  void _setRandomMigraineInfo() {
    final Random random = Random();
    final int randomIndex = random.nextInt(_migraineInfoList.length);
    setState(() {
      _randomMigraineInfo = _migraineInfoList[randomIndex];
    });
  }

/*
  Future<void> _loadAge() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      age = prefs.getString('age') ?? '25'; // Default age is 25 if not found
    });
  }
  */

  Future<List<dynamic>> _loadData() async {
    //await _loadAge();
    final impact = Impact();
    final todaySleep = await impact.getTodaySleep();
    final todayStress = await HeadacheScore().getStress();
    final todayWeather = await HeadacheScore().getWeather();
    final lastDateExercise = await impact.getLastExerciseDate();
    return [todaySleep, todayStress, todayWeather, lastDateExercise];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Palette.white,
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "What can you do?",
                style: WorkSans.titleSmall.copyWith(color: Palette.deepBlue),
              ),
              backgroundColor: Palette.white,
              iconTheme: IconThemeData(color: Palette.deepBlue),
            ),
            body: Stack(
              children: [
                // Background
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipPath(
                    child: CurvedBackground(
                      height: MediaQuery.of(context).size.height * 0.25,
                      color: Palette.blue,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: FutureBuilder<dynamic>(
                      future: _loadData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error');
                        } else {
                          final data = snapshot.data;
                          return Column(
                            children: [
                              Positioned(
                                top: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Did you know...?',
                                          style: WorkSans.titleSmall,
                                        ),
                                      ),
                                      if (_randomMigraineInfo != null)
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                40,
                                            child: RandomInfoCard(
                                                migraineInfo:
                                                    _randomMigraineInfo!)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'Try some of our solutions:',
                                    style: WorkSans.titleSmall,
                                        //.copyWith(color: Colors.grey[400]),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: FlutterCarousel(
                                  options: CarouselOptions(
                                    viewportFraction: 0.9,
                                    height: 430,
                                    showIndicator: true,
                                    indicatorMargin: 0,
                                    slideIndicator: CircularWaveSlideIndicator(
                                      indicatorBackgroundColor: Palette.deepBlue,
                                      currentIndicatorColor: Palette.white,
                                    ),
                                  ),
                                  items: _getSolutions(data!).map((solution) {
                                    return Builder(
                                        builder: (BuildContext context) {
                                      return Column(
                                        children: [
                                          Container(
                                            height: 150,
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(17, 0, 17, 15),
                                              child: Text(
                                                solution.description,
                                                style: WorkSans.bodyMedium.copyWith(color: Palette.deepBlue,),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ),
                                          SolutionCard(
                                            solution: solution,
                                          ),
                                        ],
                                      );
                                    });
                                  }).toList(),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                ),
                
              ],
            )
          )
        );
  }

  List<Solution> _getSolutions(List<dynamic> data) {
    List<Solution> solutions = List.from(_fixedSolutions);
    if (needSleep(data[0])) {
      solutions.add(
          Solution('Sleeping', 'assets/spotify.png', 'description', pageRoute: SleepingSol()));
    }
    if (needExercise()) {
      solutions.add(
          Solution('Exercise', 'assets/spotify.png', 'description', pageRoute: ExerciseSol()));
    }
    return solutions;
  }

  bool needSleep(double todaySleep) {
    int sleepNeeded;

    if (age <= 12) {
      sleepNeeded = 9;
    } else if (age >= 13 && age <= 18) {
      sleepNeeded = 8;
    } else {
      sleepNeeded = 7;
    }
    return todaySleep < sleepNeeded;
  }

  bool needExercise() {
    return true;
  }
}
