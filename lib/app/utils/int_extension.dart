extension IntegerExtension on int {
  String toMinutes() {
    return "${this ~/ 60}:${this % 60} mins";
  }
}
