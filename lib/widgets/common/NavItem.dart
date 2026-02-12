import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      onPressed: fonctionOnPressed,
      icon: Icon(this.icon),

    );
  }

  void fonctionOnPressed() {
    print("Button ${this.name} pressed");
  }

}