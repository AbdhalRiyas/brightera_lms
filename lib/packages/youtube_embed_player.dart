import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeEmbedPlayer extends StatefulWidget {
  final WebViewController controller;

  const YoutubeEmbedPlayer({super.key, required this.controller});

  @override
  State<YoutubeEmbedPlayer> createState() => _YoutubeEmbedPlayerState();
}

class _YoutubeEmbedPlayerState extends State<YoutubeEmbedPlayer> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize WebViewController
    widget.controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true; // Show overlay
            });
          },
          onPageFinished: (String url) {
            _injectJavaScript();
            setState(() {
              _isLoading = false; // Hide overlay after rendering
            });
          },
        ),
      );

    // Handle fullscreen changes
    widget.controller.addJavaScriptChannel(
      'FullscreenChannel',
      onMessageReceived: (JavaScriptMessage message) {
        final isFullscreen = message.message == 'true';
        if (isIOS) {
          if (!isFullscreen) {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]);
          } else {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]);
          }
        } else {
          if (isFullscreen) {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]);
          } else {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]);
          }
        }
      },
    );
  }

  // Method to inject JavaScript
  void _injectJavaScript() {
    widget.controller.runJavaScript('''
      // Wait for the elements to be rendered
      const waitForElements = (selector, callback) => {
        const elements = document.querySelectorAll(selector);
        if (elements.length) {
          callback(elements);
        } else {
          const observer = new MutationObserver((mutations, obs) => {
            const elements = document.querySelectorAll(selector);
            if (elements.length) {
              callback(elements);
              obs.disconnect();
            }
          });
          observer.observe(document, { childList: true, subtree: true });
        }
      };

      // Hide UI elements except fullscreen, settings, play/pause, and volume buttons
      waitForElements('.ytp-button', (buttons) => {
        buttons.forEach(button => {
          if (!button.classList.contains('ytp-fullscreen-button') && 
              !button.classList.contains('ytp-settings-button') && 
              !button.classList.contains('ytp-play-button') && !button.classList.contains('ytp-large-play-button') &&
              !button.classList.contains('ytp-mute-button')) {
            button.style.display = 'none';
          }
        });
      });

      waitForElements('.ytp-ce-element, .ytp-upnext, .ytp-chrome-top, .ytp-show-tiles', (elements) => {
        elements.forEach(element => element.style.display = 'none');
      });

      // Hide more options button inside settings menu
      const observer = new MutationObserver(() => {
        document.querySelectorAll('.ytp-settings-menu .ytp-panel-menu .ytp-menuitem').forEach(item => {
          if (item.innerText.includes('More options')) {
            item.style.display = 'none';
          }
        });
      });
      observer.observe(document.body, { childList: true, subtree: true });

      // Listen for fullscreen changes
      setInterval(() => {
        const isFullscreen = document.fullscreenElement !== null;
        console.log(isFullscreen);
        if (isFullscreen !== window.isFullscreen) {
          window.isFullscreen = isFullscreen;
          FullscreenChannel.postMessage(isFullscreen);
        }
      }, 100);
    ''');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: widget.controller),
        // Overlay when loading
        if (_isLoading)
          Container(
            color:
                Colors.black.withValues(alpha: 0.5), // Semi-transparent overlay
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }
}

String getEmbedUrl(String videoUrl) {
  String? videoId = Uri.parse(videoUrl).queryParameters['v'];
  videoId ??= videoUrl.split('/').last; // Handle shortened URLs
  return "https://www.youtube.com/embed/$videoId?autoplay=0&controls=1&modestbranding=1&rel=0&showinfo=0&fs=1";
}
