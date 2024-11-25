extension NumberExtension on num {
  String toMinutes() {
    return "${this ~/ 60}:${this % 60} mins";
  }
}
