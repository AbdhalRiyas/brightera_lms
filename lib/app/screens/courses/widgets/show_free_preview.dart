import 'package:app/app/config/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void showFreePreview(BuildContext context, String source) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusLarge),
        child: YoutubePlayer(
          controller: YoutubePlayerController(
              initialVideoId: YoutubePlayer.convertUrlToId(source) ?? ''),
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.amber,
          progressColors: const ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
        ),
      ),
    ),
  );
}
