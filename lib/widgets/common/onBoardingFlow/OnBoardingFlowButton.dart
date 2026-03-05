import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../services/onboarding_storage.dart';

class OnBoardingFlowButton extends StatelessWidget {

  final String route;
  final String child;

  const OnBoardingFlowButton(
    {
      super.key,
      required this.route,
      required this.child
    }
  );

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;

    return TextButton(
        onPressed: () async {

          // Si on est sur l'écran d'onboarding
          if (GoRouterState.of(context).uri.path == "/first-screen") {
            await OnboardingStorage.complete();
          }

          context.go(this.route);
        },
        child: Text(
          '${this.child} >',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.06,
              color: Theme.of(context).colorScheme.onSurface
          ),
        )
    );
  }

}