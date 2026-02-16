import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:r411alto/widgets/common/NavItem.dart';

class Headerhomescreen extends StatelessWidget {
  const Headerhomescreen(
      {
        super.key
      }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
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
                  Text("User name"),

                ],
              ),
            ),
          ),

          Container(
            child: IconButton(
              icon: Icon(Icons.settings),
              iconSize: 35,
              onPressed: () {
                context.go("/settings");
              },
            ),
          )
        ],
      ),

    );
  }

}