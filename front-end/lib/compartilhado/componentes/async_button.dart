import 'package:flutter/material.dart';

class AsyncButton extends StatelessWidget {
  const AsyncButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isBusy,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool isBusy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isBusy ? null : onPressed,
      icon: isBusy
          ? const SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon),
      label: Text(label),
    );
  }
}
