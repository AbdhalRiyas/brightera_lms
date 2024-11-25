import 'package:flutter/material.dart';

class ResultHandler {
  static final ResultHandler _instance = ResultHandler._internal();

  factory ResultHandler() {
    return _instance;
  }

  ResultHandler._internal();

  void _clear(context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  void showSuccess(BuildContext context, String message) {
    _clear(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.green,
    ));
  }

  void showError(BuildContext context, String message) {
    _clear(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.red,
    ));
  }
}
