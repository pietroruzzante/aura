import 'package:aura/models/palette.dart';
import 'package:aura/models/work_sans.dart';
import 'package:flutter/material.dart';

class YogaExercise {
  final String name;
  final List<String> description;
  final IconData icon;
  final String imagePath;

  YogaExercise({
    required this.name,
    required this.description,
    required this.icon,
    required this.imagePath,
  });
}

class YogaSol extends StatelessWidget {
  final List<YogaExercise> yogaExercises = [
    YogaExercise(
      name: 'Shoulder Stand',
      description: [
        'Lie on your back with your arms by your sides.',
        'Lift your legs and hips towards the ceiling, supporting your back with your hands.',
        'Keep your elbows shoulder-width apart and your legs straight.',
        'Hold the pose, keeping your body in a straight line.',
      ],
      icon: Icons.self_improvement,
      imagePath: 'assets/shoulder_stand.png',
    ),
    YogaExercise(
      name: 'Scorpion Pose',
      description: [
        'Start in a forearm stand, with your forearms on the ground and your body lifted.',
        'Slowly bend your knees and arch your back, bringing your feet towards your head.',
        'Balance and hold the pose, engaging your core and keeping your elbows steady.',
      ],
      icon: Icons.accessibility_new,
      imagePath: 'assets/scorpion_pose.png',
    ),
    YogaExercise(
      name: 'Standing Forward Bend',
      description: [
        'Stand with your feet hip-width apart.',
        'Exhale and bend forward from your hips, keeping your spine straight.',
        'Let your head and arms hang towards the floor.',
        'You can place your hands on the ground, your shins, or hold your elbows.',
      ],
      icon: Icons.accessibility_new,
      imagePath: 'assets/standing_forward_bend.png',
    ),
    YogaExercise(
      name: "Child's Pose",
      description: [
        'Kneel on the floor with your big toes touching and your knees spread apart.',
        'Sit back on your heels and stretch your arms forward, lowering your torso between your thighs.',
        'Rest your forehead on the mat and relax your shoulders.',
        'Breathe deeply and hold the pose.',
      ],
      icon: Icons.child_care,
      imagePath: 'assets/child_pose.png',
    ),
    YogaExercise(
      name: 'Bow Pose',
      description: [
        'Lie on your stomach with your arms at your sides.',
        'Bend your knees and reach back to grab your ankles.',
        'Inhale and lift your chest and legs off the ground, pulling your ankles towards your head.',
        'Hold the pose, keeping your neck in a neutral position and breathing steadily.',
      ],
      icon: Icons.self_improvement,
      imagePath: 'assets/bow_pose.png',
    ),
    YogaExercise(
      name: 'Splits',
      description: [
        'Start in a low lunge position with your right foot forward and left knee on the ground.',
        'Gradually slide your right foot forward and your left foot back, lowering your hips towards the ground.',
        'Use your hands for support on either side of your hips.',
        'Hold the pose, keeping your torso upright and hips squared.',
      ],
      icon: Icons.accessibility_new,
      imagePath: 'assets/splits.png',
    ),
    YogaExercise(
      name: 'Easy Pose',
      description: [
        'Sit on the floor with your legs crossed.',
        'Place your hands on your knees with your palms facing up or down.',
        'Sit up straight, lengthening your spine and relaxing your shoulders.',
        'Close your eyes and focus on your breath.',
      ],
      icon: Icons.self_improvement,
      imagePath: 'assets/easy_pose.png',
    ),
    YogaExercise(
      name: 'Boat Pose',
      description: [
        'Sit on the floor with your knees bent and feet flat on the ground.',
        'Lean back slightly and lift your feet off the ground, balancing on your sit bones.',
        'Straighten your legs and extend your arms forward, parallel to the floor.',
        'Hold the pose, keeping your spine straight and engaging your core.',
      ],
      icon: Icons.self_improvement,
      imagePath: 'assets/boat_pose.png',
    ),
    YogaExercise(
      name: 'Camel Pose',
      description: [
        'Kneel on the floor with your knees hip-width apart.',
        'Place your hands on your lower back for support.',
        'Inhale and arch your back, reaching your hands towards your heels.',
        'Keep your chest lifted and your neck in a neutral position.',
        'Hold the pose, breathing deeply.',
      ],
      icon: Icons.accessibility_new,
      imagePath: 'assets/camel_pose.png',
    ),
    YogaExercise(
      name: 'Dancer Pose',
      description: [
        'Stand tall with your feet together.',
        'Shift your weight onto your left foot and bend your right knee, lifting your right foot behind you.',
        'Reach back with your right hand to grab your right ankle.',
        'Extend your left arm forward and lean your torso forward while lifting your right leg higher.',
        'Hold the pose, maintaining your balance and breathing steadily.',
      ],
      icon: Icons.accessibility_new,
      imagePath: 'assets/dancer_pose.png',
    ),
    YogaExercise(
      name: 'Downward-Facing Dog',
      description: [
        'Start on your hands and knees, with your wrists aligned under your shoulders and knees under your hips.',
        'Tuck your toes under and lift your hips towards the ceiling, straightening your legs.',
        'Press your hands into the mat and extend your spine, forming an inverted V-shape.',
        'Keep your head between your arms and your heels reaching towards the ground.',
        'Hold the pose, breathing deeply.',
      ],
      icon: Icons.self_improvement,
      imagePath: 'assets/downward_facing_dog.png',
    ),
    YogaExercise(
      name: 'Warrior III',
      description: [
        'Stand with your feet together and arms by your sides.',
        'Shift your weight onto your left foot and lift your right leg behind you.',
        'Extend your torso forward and bring your arms out in front of you, parallel to the ground.',
        'Keep your body in a straight line from your fingertips to your lifted foot.',
        'Hold the pose, balancing and engaging your core.',
      ],
      icon: Icons.accessibility_new,
      imagePath: 'assets/warrior_iii.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.white,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Yoga',
            style: WorkSans.titleSmall,
          ),
          backgroundColor: Palette.white,
          iconTheme: const IconThemeData(color: Palette.deepBlue),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            itemCount: yogaExercises.length,
            itemBuilder: (context, index) {
              return YogaExerciseCard(
                exercise: yogaExercises[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YogaExerciseDetailScreen(
                        exercise: yogaExercises[index],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class YogaExerciseCard extends StatelessWidget {
  final YogaExercise exercise;
  final VoidCallback onTap;

  YogaExerciseCard({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        color: Palette.white,
        elevation: 10,
        shadowColor: Palette.softBlue2,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                exercise.icon,
                size: 50,
                color: Palette.blue,
              ),
              const SizedBox(height: 10),
              Text(exercise.name,
                  textAlign: TextAlign.center,
                  style: WorkSans.bodyMedium.copyWith(
                      color: Palette.deepBlue, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class YogaExerciseDetailScreen extends StatelessWidget {
  final YogaExercise exercise;

  YogaExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.white,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            exercise.name,
            style: WorkSans.titleSmall,
          ),
          backgroundColor: Palette.white,
          iconTheme: const IconThemeData(color: Palette.deepBlue),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                color: Palette.white,
                elevation: 10,
                shadowColor: Palette.softBlue2,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Icon(
                          exercise.icon,
                          size: 100,
                          color: Palette.blue,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          exercise.description.join('\n'),
                          style: WorkSans.bodyMedium
                              .copyWith(color: Palette.deepBlue),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 300,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  color: Palette.white,
                  elevation: 10,
                  shadowColor: Palette.softBlue2,
                  child: Center(
                    child: Image.asset(
                      exercise.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
