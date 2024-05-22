import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MichaelSol extends StatelessWidget {
  final String videoId =
      'aiMcewLra2g'; // ID del video di YouTube da visualizzare

  @override
  Widget build(BuildContext context) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Try Michael\'s Solution',
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
                topActions: <Widget>[
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      _controller.metadata.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    onPressed: () {
                      // Logica per i pulsanti
                    },
                  ),
                ],
                onReady: () {
                  print('Player is ready.');
                },
                onEnded: (data) {
                  _controller.load(videoId); // Ripeti il video quando termina
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Video Ended!')),
                  );
                },
              ),
            ),
            SizedBox(height: 20,),
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
