import 'dart:developer';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YouTubeService {
  final YoutubeExplode yt = YoutubeExplode();

  Future<Map<String, String?>> getVideoAndAudioUrls(String videoId) async {
    print(videoId);
    try {
      var manifest = await yt.videos.streams.getManifest(videoId);

      log(manifest.videoOnly.toString());
      log(manifest.audioOnly.toString());

      String? videoUrl;
      String? audioUrl;

      if (manifest.videoOnly.isNotEmpty) {
        var videoStreamInfo = manifest.videoOnly.withHighestBitrate();
        videoUrl = videoStreamInfo.url.toString();
      }

      if (manifest.audioOnly.isNotEmpty) {
        var audioStreamInfo = manifest.audioOnly.withHighestBitrate();
        audioUrl = audioStreamInfo.url.toString();
      }

      return {'videoUrl': videoUrl, 'audioUrl': audioUrl};
    } catch (e) {
      print("Error fetching video URL: $e");
      return {'videoUrl': null, 'audioUrl': null};
    }
  }

  void dispose() {
    yt.close();
  }
}
