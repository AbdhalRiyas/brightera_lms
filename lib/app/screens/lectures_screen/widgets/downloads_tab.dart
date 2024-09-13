import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/active_lesson.dart';
import 'package:app/app/models/download.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadsTab extends StatefulWidget {
  const DownloadsTab({
    super.key,
    required this.activeLesson,
  });

  final ValueListenable<ActiveLesson> activeLesson;

  @override
  State<DownloadsTab> createState() => _DownloadsTabState();
}

class _DownloadsTabState extends State<DownloadsTab> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ActiveLesson>(
        valueListenable: widget.activeLesson,
        builder: (context, value, ch) {
          List<Download> downloadObjects = value.downloads
              .map((download) => Download.fromJson(download))
              .toList();
          return value.downloads.isEmpty
              ? const Center(
                  child: Text(
                      "There are no downloads available for this lecture."),
                )
              : ListView.builder(
                  itemCount: downloadObjects.length,
                  itemBuilder: (_, i) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(downloadObjects[i].name),
                    leading: const Icon(Icons.file_present),
                    onTap: () =>
                        _showExternalDownloadAlert(downloadObjects[i].link),
                    trailing: IconButton(
                        onPressed: () =>
                            _showExternalDownloadAlert(downloadObjects[i].link),
                        icon: const Icon(Icons.download_for_offline_outlined)),
                  ),
                );
        });
  }

  void _showExternalDownloadAlert(Uri uri) => showDialog(
      context: context,
      builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Are you sure you want to download this file via a browser?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: ThemeConstants.paddingMedium),
                ElevatedButton(
                  onPressed: () async {
                    if (!await launchUrl(uri)) {
                      throw Exception('Could not launch $uri');
                    } else {
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text(
                    "Open & Download via Browser",
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ));
}
