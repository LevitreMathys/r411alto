import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:r411alto/models/activated_buttons.dart';

class ActivatedButtonsNotifier extends Notifier<ActivatedButtons>{
  @override
  ActivatedButtons build() {
    return const ActivatedButtons(
        isActivated: false
    );
  }

  void setIsActivatedValue(bool value) {
    state = state.copyWith(isActivated: value);
  }

  void reset() {
    state = const ActivatedButtons(isActivated: false);
  }
}