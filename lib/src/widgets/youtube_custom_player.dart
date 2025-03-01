import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class MultiStreamPlayer extends StatefulWidget {
  final String videoUrl;
  final String audioUrl;

  const MultiStreamPlayer({required this.videoUrl, required this.audioUrl});

  @override
  _MultiStreamPlayerState createState() => _MultiStreamPlayerState();
}

class _MultiStreamPlayerState extends State<MultiStreamPlayer> {
  late VlcPlayerController _videoController;
  late VlcPlayerController _audioController;

  @override
  void initState() {
    super.initState();

    // Initialize video player
    _videoController = VlcPlayerController.network(
      widget.videoUrl,
      options: VlcPlayerOptions(),
    );

    // Initialize audio player
    _audioController = VlcPlayerController.network(
      widget.audioUrl,
      options: VlcPlayerOptions(),
    );

    // Play both streams
    _videoController.play();
    _audioController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Column(
        children: [
          // Video Player
          Expanded(
            child: VlcPlayer(
              controller: _videoController,
              aspectRatio: 16 / 9,
              placeholder: Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioController.dispose();
    super.dispose();
  }
}
