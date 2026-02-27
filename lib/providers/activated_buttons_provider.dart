import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:r411alto/models/activated_buttons.dart';
import 'package:r411alto/notifiers/activated_buttons_notifier.dart';

final activatedButtonsNotifier = NotifierProvider<ActivatedButtonsNotifier, ActivatedButtons>(
  ActivatedButtonsNotifier.new,
);

