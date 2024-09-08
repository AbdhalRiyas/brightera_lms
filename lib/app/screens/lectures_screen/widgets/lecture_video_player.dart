import 'package:app/app/config/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LectureVideoPlayer extends StatefulWidget {
  const LectureVideoPlayer({super.key, required this.toggleFullScreen});

  final Function toggleFullScreen;

  @override
  State<LectureVideoPlayer> createState() => _LectureVideoPlayerState();
}

class _LectureVideoPlayerState extends State<LectureVideoPlayer> {
  late YoutubePlayerController _controller;
  bool _isFullScreen = false;
  bool _isControlsVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'yz6CXqaH4hc',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    // Add a listener to track fullscreen mode

    _controller.addListener(_playerListener);
  }

  void _replayBackward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    _controller.seekTo(const Duration(seconds: 0) > newPosition
        ? const Duration(seconds: 0)
        : newPosition);
  }

  void _skipForward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition + const Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  void _playerListener() {
    bool isStateChanged = false;
    if (mounted) {
      if (_controller.value.isControlsVisible != _isControlsVisible) {
        if (!_isControlsVisible) {
          _isControlsVisible = true;
          isStateChanged = true;
        } else {
          _isControlsVisible = false;
          isStateChanged = true;
        }
      }

      // else {
      //   if (_isControlsVisible != false) {
      //     _isControlsVisible = false;
      //     _isStateChanged = true;
      //   }
      // }

      if (_isFullScreen != _controller.value.isFullScreen) {
        _isFullScreen = _controller.value.isFullScreen;
        isStateChanged = true;
        widget.toggleFullScreen(_controller.value.isFullScreen);
      }

      if (isStateChanged) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_playerListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      aspectRatio: 16 / 9,
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: ThemeConstants.primaryColor,
      progressColors: const ProgressBarColors(
        playedColor: ThemeConstants.accentColor,
        handleColor: ThemeConstants.primaryColor,
      ),
      onReady: () {
        // Additional setup if needed
      },
    );
  }
}
