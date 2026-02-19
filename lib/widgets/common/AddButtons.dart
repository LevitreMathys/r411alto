import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:r411alto/widgets/common/NavItem.dart';

class AddButtons extends StatelessWidget {
  const AddButtons(
      {
        super.key
      }
  );

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 110,
      left: 50,
      right: 130,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),

          child:
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // espace équitablement les item de la navbar
                children: [
                  TextButton(
                      onPressed: () {
                        context.push("/qr-code");
                      },
                      child: Text("Créer une connexion")
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // espace équitablement les item de la navbar
                children: [
                  TextButton(
                      onPressed: () {
                        context.push("/scan-qr-code");
                      },
                      child: Text("Scanner un QR Code")
                  )
                ],
              )
              .animate()
              .fade(curve: Curves.easeOut)
              .,
            ]
          ),
        )

      )
    );
  }
}