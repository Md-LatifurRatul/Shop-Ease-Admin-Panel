import 'package:flutter/material.dart';

class SnackMessage {
  static void showSnackMessage(
    BuildContext context,
    String msg, {
    Color backGroundColor = Colors.black87,
    Duration duration = const Duration(milliseconds: 800),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backGroundColor,
        duration: duration,
        content: Text(msg),
      ),
    );
  }
}
