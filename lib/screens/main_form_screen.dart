import 'package:flutter/material.dart';
import 'package:r411alto/widgets/common/onBoardingFlow/Input.dart';
import 'package:r411alto/widgets/common/onBoardingFlow/OnBoardingFlowButton.dart';
import 'package:r411alto/widgets/common/onBoardingFlow/RegistrationForm.dart';

class MainFormScreen extends StatelessWidget {
  const MainFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
            children: [

              // Background top
              Positioned(
                  top: -30,
                  right: 0,
                  child: IgnorePointer(
                    child: Image.asset(
                        'assets/images/Group17.png'
                    ),
                  )
              ),

              Positioned.fill(
                child: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 380),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              /// TITRE (centré)
                              Center(
                                child: Text(
                                  "Création du compte",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.07,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              /// TEXTE (centré)
                              Center(
                                child: Text(
                                  "Pour créer votre compte, veuillez remplir le formulaire",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 30),

                              /// FORMULAIRE (pleine largeur du bloc)
                              RegistrationForm(),

                              const SizedBox(height: 35),

                              /// BOUTON ALIGNÉ À GAUCHE
                              OnBoardingFlowButton(
                                route: "/",
                                child: "Continuer",
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Background bottom
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Image.asset(
                        'assets/images/Group16.png'
                    ),
                  )
              ),
            ]
        )
    );
  }
}

