import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:r411alto/widgets/common/onBoardingFlow/OnBoardingFlowButton.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [

          // Background top
          Positioned(
            top: 0,
            right: 0,
            child: IgnorePointer(
              child: Image.asset(
                  'assets/images/Group13.png'
              ),
            )
          ),

          Align(
            alignment: const Alignment(0, 0.28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Emplacement du titre
                Padding(
                    padding: const EdgeInsets.only(
                        left: 37
                    ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    // Titre principal
                    child: Text("BIENVENUE \nSUR ALTO",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.1
                      ),
                    ),
                  )
                ),

                Padding(
                    // Ajout d'un padding left de 37
                    padding: const EdgeInsets.only(
                        left: 37
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      // Texte de présentation
                      child: Text.rich(
                        TextSpan(
                          text: "Voici l’espace configuration qui te permettera de personnaliser le plus possible ton expérience ",
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                          ),
                          children:
                            const [
                              TextSpan(
                                text: "ALTO",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                )
                              )
                            ]
                        ),

                      )
                    )
                ),

                // Bouton "Commencer"
                Padding(
                    padding: const EdgeInsets.only(
                      top: 50,
                      right: 37
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: OnBoardingFlowButton(
                          route: "/sign-up",
                          child: "Commencer"
                      )
                    )
                )
              ],
            ),
          ),

          // Background bottom
          Positioned(
              bottom: 0,
              left: 0,
              child: IgnorePointer(
                child: Image.asset(
                    'assets/images/Group15.png'
                ),
              )
          ),
        ]
      )
    );
  }
}

