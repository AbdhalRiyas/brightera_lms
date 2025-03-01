import 'package:app/src/config/app_contants.dart';
import 'package:app/src/config/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

void showFreePreview(BuildContext context, String source) {
  final videoId = YoutubePlayerController.convertUrlToId(source) ?? '';

  final controller = YoutubePlayerController(
    params: const YoutubePlayerParams(
      mute: false,
      showControls: false,
      color: 'white',
      showFullscreenButton: true,
    ),
  );

  controller.loadVideoById(videoId: videoId);

  showDialog(
    context: context,
    builder: (_) => Padding(
      padding: const EdgeInsets.all(ThemeConstants.paddingLarge),
      child: YoutubePlayerScaffold(
        controller: controller,
        builder: (context, player) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              player,
              Text('Youtube Player'),
            ],
          );
        },
      ),
    ),
  );
}
