import 'package:aura/models/palette.dart';
import 'package:flutter/material.dart';

class YogaExercise {
  final String name;
  final String description;
  final IconData icon;

  YogaExercise({
    required this.name,
    required this.description,
    required this.icon,
  });
}

class YogaScreen extends StatelessWidget {
  final List<YogaExercise> yogaExercises = [
    YogaExercise(
      name: 'Mountain Pose',
      description: 'Stand tall with feet together, shoulders relaxed, weight evenly distributed through your soles, arms at sides.',
      icon: Icons.self_improvement,
    ),
    YogaExercise(
      name: 'Downward-Facing Dog',
      description: 'The body is positioned in an inverted "V" with the palms and feet rooted into the earth and sits bones lifted up toward the sky. The arms and legs are straight. The weight of the body is equally distributed between the hands and the feet. The eye of the elbows face forward. The ribcage is lifted and the heart is open. Shoulders are squared to the earth and rotated back, down and inward. The neck is relaxed and the crown of the head is toward the earth. The gaze is down and slightly forward.',
      icon: Icons.self_improvement,
    ),
    YogaExercise(
      name: 'Standing Forward Bend',
      description: 'From a standing position, the body is folded over at the crease of the hip with the spine long. The neck is relaxed and the crown of the head is toward the earth. The feet are rooted into the earth with the toes actively lifted. The spine is straight. The ribcage is lifted. The chest and the thighs are connected. The sacrum lifts up toward the sky in dog tilt. The fingertips are resting on the earth next to the toes. The gaze is down or slightly forward.',
      icon: Icons.accessibility_new,
    ),
    YogaExercise(
      name: 'Fire Log',
      description: 'From a seated position, stack both shins on top of each other until they are parallel to the front edge of the mat.',
      icon: Icons.flare,
    ),
    YogaExercise(
      name: "Child's Pose",
      description: 'From a kneeling position, the toes and knees are together with most of the weight of the body resting on the heels of the feet. The arms are extended back resting alongside the legs. The forehead rests softly onto the earth. The gaze is down and inward.',
      icon: Icons.child_care,
    ),
    YogaExercise(
      name: 'Corpse Pose',
      description: 'The body rests on the earth in a supine position with the arms resting by the side body. The palms are relaxed and open toward the sky. The shoulder blades are pulled back, down and rolled under comfortably, resting evenly on the earth. The legs are extended down and splayed open. The heels are in and the toes flop out. The eyes are closed. Everything is relaxed. The gaze is inward.',
      icon: Icons.bed,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yoga Exercises'),
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
    );
  }
}

class YogaExerciseCard extends StatelessWidget {
  final YogaExercise exercise;
  final VoidCallback onTap;

  YogaExerciseCard({
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                exercise.icon,
                size: 50,
                color: Palette.blue,
              ),
              SizedBox(height: 10),
              Text(
                exercise.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class YogaExerciseDetailScreen extends StatelessWidget {
  final YogaExercise exercise;

  YogaExerciseDetailScreen({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              exercise.icon,
              size: 100,
              color: Palette.blue,
            ),
            SizedBox(height: 20),
            Text(
              exercise.description,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}