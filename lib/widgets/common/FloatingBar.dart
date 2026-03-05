import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:r411alto/widgets/common/NavItem.dart';

import '../../providers/activated_buttons_provider.dart';

class FloatingBar extends ConsumerStatefulWidget {
  const FloatingBar({super.key});

  @override
  ConsumerState<FloatingBar> createState() => _FloatingBarState();
}

class _FloatingBarState extends ConsumerState<FloatingBar> {
  @override
  Widget build(BuildContext context) {

    final double iconSize = 30;

    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          NavItem(icon: Icons.message_outlined, name: "message", size: iconSize,),

          // Bouton Add
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              final notifier = ref.read(activatedButtonsNotifier.notifier);
              final current = ref.read(activatedButtonsNotifier).isActivated;
              notifier.setIsActivatedValue(!current);
            },
            iconSize: iconSize,
          ),

          NavItem(icon: Icons.house, name: "home", size: iconSize,),
          NavItem(icon: Icons.account_circle, name: "profil", size: iconSize,),
        ],
      ),
    );

  }
}

