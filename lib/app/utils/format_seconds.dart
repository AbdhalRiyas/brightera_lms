String formatSeconds(int seconds) {
  Duration duration = Duration(seconds: seconds);

  // Extract minutes and seconds from Duration
  String minutes = duration.inMinutes.toString().padLeft(2, '0');
  String remainingSeconds =
      (duration.inSeconds % 60).toString().padLeft(2, '0');

  return "$minutes:$remainingSeconds";
}
