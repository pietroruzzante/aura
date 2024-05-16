import 'package:aura/models/palette.dart';
import 'package:flutter/material.dart';

class SpotifySol extends StatelessWidget {
  const SpotifySol({super.key});

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chill with some tunes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Color.fromARGB(255, 29, 185, 84),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Center(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Sai che ascoltare musica può dare una mano quando hai un brutto mal di testa? Sembra strano, ma è vero! La musica riesce a distrarti dal dolore, e può persino rilassare i muscoli tesi.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Palette.white),
                      textAlign: TextAlign.justify,
                    ),
                  )
                ),
              ),
            ),
            ElevatedButton(
              child: Text('To the home'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
  
}