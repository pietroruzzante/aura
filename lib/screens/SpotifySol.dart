import 'package:aura/models/palette.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotifySol extends StatelessWidget {
  const SpotifySol({super.key});

  final String _spotifyUrl = 'https://open.spotify.com/playlist/2bz6wk2mbPgF9ZNXhLN4Ts?si=0fe7203fa4364f4e';

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Uri toLaunch = Uri.parse(_spotifyUrl);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chill with some tunes',
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Color.fromARGB(255, 29, 185, 84),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Center(
                child: Container(
                    child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Music',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Palette.white),
                    textAlign: TextAlign.justify,
                  ),
                )),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text('Open Spotify'),
              onPressed: ()  => _launchUrl(toLaunch),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text('Other solutions'),
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
