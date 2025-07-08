import 'package:flutter/material.dart';

class CustomUploadButton extends StatelessWidget {
  final String label; // Required label text
  final void Function()? onPressed; // Nullable function for button press

  const CustomUploadButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
