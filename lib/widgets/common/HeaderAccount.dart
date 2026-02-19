import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'NavItem.dart';

class Headeraccount extends StatelessWidget {

  final String user_name;

  const Headeraccount({
    super.key,
    required this.user_name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: () {
          context.go("/profil-setting");
        },
        child: Row(
          children: [
            NavItem(
              icon: Icons.account_circle,
              name: "profil",
              size: 35,
            ),
            Text(
              this.user_name,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface
              ),
            ),

          ],
        ),
      ),
    );
  }
}