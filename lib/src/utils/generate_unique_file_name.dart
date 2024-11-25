import 'dart:math';

String generateUniqueFileName(String extension) {
  final random = Random();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final randomNumber = random.nextInt(1000000); // Generate a random number

  // Create a unique file name with timestamp and random number
  return '${timestamp}_$randomNumber.$extension';
}
