import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:r411alto/widgets/common/NavItem.dart';

class FloatingBar extends StatelessWidget {
  const FloatingBar({super.key});

  @override
  Widget build(BuildContext context) {

    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 20,
      left: 20,
      right: 20,
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

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // espace équitablement les item de la navbar
            children: [
              NavItem(icon: Icons.message_outlined, name: "message"),
              GestureDetector(
                onTap: () {
                  // Navigate to QR code generation screen using go_router
                  context.push('/qr-code');
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF6366F1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              NavItem(icon: Icons.account_circle, name: "profile"),
            ],
          ),
        ),
      ),
    );


  }

}
