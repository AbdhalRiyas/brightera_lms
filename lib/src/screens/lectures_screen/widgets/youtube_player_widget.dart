import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final YoutubePlayerController controller;

  const YoutubePlayerWidget({
    super.key,
    required this.controller,
    required this.nextVideo,
    required this.prevVideo,
  });

  final VoidCallback prevVideo;
  final VoidCallback nextVideo;

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  bool _isFullScreen = false;

  bool _isControlsVisible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_playerListener);
  }

  void _replayBackward() {
    final currentPosition = widget.controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    widget.controller.seekTo(newPosition < const Duration(seconds: 0)
        ? const Duration(seconds: 0)
        : newPosition);
  }

  void _skipForward() {
    final currentPosition = widget.controller.value.position;
    final newPosition = currentPosition + const Duration(seconds: 10);
    widget.controller.seekTo(newPosition);
  }

  void _playerListener() {
    if (mounted) {
      if (_isFullScreen != widget.controller.value.isFullScreen) {
        setState(() {
          _isFullScreen = widget.controller.value.isFullScreen;
        });
      }

      if (widget.controller.value.isControlsVisible != _isControlsVisible) {
        setState(() {
          _isControlsVisible = !_isControlsVisible;
        });
      }
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_playerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        YoutubePlayer(
          controller: widget.controller,
          showVideoProgressIndicator: true,
          bottomActions: [
            const SizedBox(width: 14.0),
            CurrentPosition(),
            const SizedBox(width: 8.0),
            ProgressBar(
              isExpanded: true,
              colors: const ProgressBarColors(
                handleColor: Colors.white,
                playedColor: Colors.white,
              ),
            ),
            RemainingDuration(),
            const PlaybackSpeedButton(
              icon: Icon(
                Icons.speed,
                color: Colors.white,
              ),
            ),
            FullScreenButton(),
          ],
        ),
        if (_isControlsVisible)
          SafeArea(
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
        if (_isControlsVisible)
          Positioned.fill(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: widget.prevVideo,
                        icon: const Icon(
                          Icons.skip_previous,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: _replayBackward,
                        icon: const Icon(
                          Icons.replay_10,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _skipForward,
                        icon: const Icon(
                          Icons.forward_10,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                      IconButton(
                        onPressed: widget.nextVideo,
                        icon: const Icon(
                          Icons.skip_next,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
