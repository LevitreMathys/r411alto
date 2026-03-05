import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:r411alto/providers/activated_buttons_provider.dart';
import 'package:r411alto/widgets/common/AddButtons.dart';
import 'package:r411alto/widgets/common/FloatingBar.dart';
import 'package:go_router/go_router.dart';
import 'package:r411alto/widgets/common/HeaderHomeScreen.dart';
<<<<<<< feature/themes
=======
import 'package:r411alto/widgets/common/PopUpAlert.dart';
>>>>>>> dev


class App extends ConsumerWidget {
  final Widget body;
  const App({super.key, required this.body});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAddButtons = ref.watch(activatedButtonsNotifier).isActivated;

    final location = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    final isHome = location == "/";

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      extendBody: true,
      body: Stack(
        children: [

          body,

          if(isHome)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Headerhomescreen(),
            ),

<<<<<<< feature/themes
=======
/*
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: SafeArea(
              child: PopUpAlert(
                  isErr: false,
                  content: "Erreur"
              )
            )
          ),
*/
>>>>>>> dev


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
          )
          .animate()
          .slideY(
            begin: 1,
            end: 0,
            duration: 400.ms,
            curve: Curves.easeIn
          ),
        ],
      ),
    );
  }
}
