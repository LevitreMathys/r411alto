import 'package:flutter/material.dart';

@immutable
class ActivatedButtons {
  final bool isActivated;

  const ActivatedButtons(
    {
      required this.isActivated
    }
  );

  ActivatedButtons copyWith({
    bool? isActivated
  }) {
    return ActivatedButtons(
        isActivated: isActivated ?? this.isActivated
    );
  }
}