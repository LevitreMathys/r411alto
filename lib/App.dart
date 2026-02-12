import 'package:flutter/material.dart';
import 'package:r411alto/widgets/common/AddButtons.dart';
import 'package:r411alto/widgets/common/FloatingBar.dart';

class App extends StatelessWidget {

  final Widget body;

  const App({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          body,

          // Background
          Positioned(
            bottom: 0,
            left: 0,
            child:
            IgnorePointer(child:
            Image(
                image: AssetImage(
                    "assets/images/Group14.png"
                )
            )
            ),
          ),

          AddButtons(),

          // Barre de navigation flottante
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
