import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        onPressed: () {
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