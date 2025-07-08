import 'package:flutter/material.dart';

class ImageSelectingButton extends StatelessWidget {
  const ImageSelectingButton({super.key, required this.label, this.onPressed});
  final String label;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.image),
      label: Text(label),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent),
    );
  }
}
