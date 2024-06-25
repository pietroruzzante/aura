import 'package:aura/models/palette.dart';
import 'package:aura/models/work_sans.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MichaelSol extends StatelessWidget {
  final String videoId = 'aiMcewLra2g';

  @override
  Widget build(BuildContext context) {
    YoutubePlayerController controller = YoutubePlayerController(
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

    return Container(
      color: Palette.white,
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
              'Michael\'s Solution',
              style: WorkSans.titleSmall,
            ),
            backgroundColor: Palette.white,
            iconTheme: const IconThemeData(color: Palette.deepBlue),
          ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 20,
                      top: 40,
                      child: SizedBox(
                        height: 160,
                        child: AspectRatio(
                          aspectRatio: 3 / 2,
                          child: YoutubePlayer(
                            controller: controller,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Palette.blue,
                            topActions: <Widget>[
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  controller.metadata.title,
                                  style: const TextStyle(
                                    color: Palette.white,
                                    fontSize: 18.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.settings,
                                  color: Palette.white,
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
                              controller.load(videoId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Video Ended!')),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,0,10,0),
                      child: Image.asset(
                        'assets/tvframe.png',
                        alignment: Alignment.center,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
