import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavItem extends StatelessWidget {

  final IconData icon;
  final String name;

  const NavItem(
      {
        super.key,
        required this.icon,
        required this.name
      }
  );

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => {
        ChangeScreen(context)
      },
      icon: Icon(this.icon),
    );
  }

  void ChangeScreen(BuildContext context) {
    switch (this.name) {

      case "home":
        context.go("/");
      case "profil":
        context.go("/profil-setting");
    }
  }

}