import 'package:app/packages/youtube_embed_player.dart';
import 'package:app/src/config/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void showFreePreview(BuildContext context, String source) {
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(
      Uri.parse(getEmbedUrl(source)),
    );
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusLarge),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: YoutubeEmbedPlayer(
            controller: controller,
          ),
        ),
      ),
    ),
  );
}
