import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LecturesScreen extends StatefulWidget {
  const LecturesScreen({super.key});

  @override
  State<LecturesScreen> createState() => _LecturesScreenState();
}

class _LecturesScreenState extends State<LecturesScreen> {
  late YoutubePlayerController _controller;
  bool _isFullScreen = false;
  bool _isControlsVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'iLnmTe5Q2Qw',
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
    if (mounted) {
      if (_controller.value.isControlsVisible) {
        if (!_isControlsVisible) {
          setState(() {
            _isControlsVisible = true;
          });
        }
      } else {
        if (_isControlsVisible) {
          setState(() {
            _isControlsVisible = false;
          });
        }
      }
      setState(() {
        _isFullScreen = _controller.value.isFullScreen;
      });
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
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'dwdw'),
          BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'dwdw'),
          BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'dwdw'),
        ],
      ),
      body: SafeArea(
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            aspectRatio: 16 / 9,
            width: double.infinity,
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
            progressColors: const ProgressBarColors(
              playedColor: Colors.amber,
              handleColor: Colors.amberAccent,
            ),
            onReady: () {
              // Additional setup if needed
            },
          ),
          builder: (context, player) {
            return Column(
              children: [
                // SliverAppBar(
                //   pinned: true,
                //   flexibleSpace: FlexibleSpaceBar(
                //     title: _isFullScreen
                //         ? null
                //         : Text(
                //             _controller.metadata.title,
                //             maxLines: 1,

                //           ),
                //   ),
                // ),
                Stack(
                  children: [
                    player,
                    if (_isControlsVisible)
                      SafeArea(
                        child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            )),
                      ),
                    if (_isControlsVisible)
                      Positioned.fill(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: _replayBackward,
                                icon: const Icon(
                                  Icons.replay_10,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: _skipForward,
                                icon: const Icon(
                                  Icons.forward_10,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
                if (!_isFullScreen) ...[
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Lecture Content",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "More details about the lecture go here.",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Lecture Content",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "More details about the lecture go here.",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Lecture Content",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "More details about the lecture go here.",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Lecture Content",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "More details about the lecture go here.",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Lecture Content",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "More details about the lecture go here.",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
