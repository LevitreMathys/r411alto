import 'package:flutter/material.dart';

void showError(
  BuildContext context,
  String message, {
  VoidCallback? onDismiss,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 4),
      action: onDismiss != null
          ? SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                onDismiss();
              },
            )
          : null,
    ),
  );
}

class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  final IconData icon;
  final Color color;

  const ErrorDisplay({
    super.key,
    required this.message,
    this.onDismiss,
    this.icon = Icons.error_outline,
    this.color = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          const Text('Erreur'),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onDismiss?.call();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
