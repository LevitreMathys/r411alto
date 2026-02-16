import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String label;
  final bool isRequired;

  const Input({
    super.key,
    required this.label,
    required this.isRequired,
  });

  @override
  Widget build(BuildContext context) {

    final bool isPassword = label.toLowerCase() == "password";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// LABEL
          Text.rich(
            TextSpan(
              text: capitalize(label),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              children: isRequired
                  ? const [
                TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red),
                )
              ]
                  : [],
            ),
          ),

          const SizedBox(height: 4),

          /// INPUT
          TextFormField(
            obscureText: isPassword,

            textAlign: TextAlign.start,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              hintText: isPassword
                  ? "Enter your password"
                  : "Enter your $label",

              /// petite icône œil pour voir le mot de passe
              suffixIcon: isPassword
                  ? const Icon(Icons.lock_outline)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  String capitalize(String word) {
    if (word.isEmpty) return "";
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }
}
