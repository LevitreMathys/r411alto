import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavItem extends StatelessWidget {

  final IconData icon;
  final String name;
  final double size;

  const NavItem(
      {
        super.key,
        required this.icon,
        required this.name,
        required this.size,
      }
  );

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => {
        ChangeScreen(context)
      },
      icon: Icon(
        this.icon,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      iconSize: this.size,
    );
  }

  void ChangeScreen(BuildContext context) {
    switch (this.name) {

      case"message":
        context.go("/first-screen");
      case "home":
        context.go("/");
      case "profil":
        context.go("/profil-setting");
    }
  }

}