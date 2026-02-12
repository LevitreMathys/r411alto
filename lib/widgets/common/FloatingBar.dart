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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          NavItem(icon: Icons.message_outlined, name: "message"),

          // Bouton Add
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              final notifier = ref.read(activatedButtonsNotifier.notifier);
              final current = ref.read(activatedButtonsNotifier).isActivated;
              notifier.setIsActivatedValue(!current);
            },
          ),

          NavItem(icon: Icons.house, name: "home"),
          NavItem(icon: Icons.account_circle, name: "profil"),
        ],
      ),
    );
  }
}

