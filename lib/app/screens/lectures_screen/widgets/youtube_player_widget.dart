import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final YoutubePlayerController controller;
  final Function onSkipForward;
  final Function onReplayBackward;

  const YoutubePlayerWidget(
      {super.key,
      required this.controller,
      required this.onSkipForward,
      required this.onReplayBackward});

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
                  IconButton(
                    onPressed: () => widget.onReplayBackward(),
                    icon: const Icon(
                      Icons.replay_10,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () => widget.onSkipForward(),
                    icon: const Icon(
                      Icons.forward_10,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
