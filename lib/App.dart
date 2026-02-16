import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:r411alto/providers/activated_buttons_provider.dart';
import 'package:r411alto/widgets/common/AddButtons.dart';
import 'package:r411alto/widgets/common/FloatingBar.dart';
import 'package:go_router/go_router.dart';


class App extends ConsumerWidget {
  final Widget body;
  const App({super.key, required this.body});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAddButtons = ref.watch(activatedButtonsNotifier).isActivated;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [

          body,

          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: IgnorePointer(
                child: Image.asset(
                  "assets/images/Group14.png",
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover, // ou BoxFit.contain selon le rendu voulu
                ),
              ),
            ),
          ),

          if (showAddButtons) AddButtons(),

          // Small Easter Egg button in top right corner
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(
                  Icons.auto_awesome,
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: () {
                  context.push("/easter-egg");
                },
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SafeArea(
              child: FloatingBar(),
            ),
          ),
        ],
      ),
    );
  }
}
