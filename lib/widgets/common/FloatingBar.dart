import 'package:flutter/material.dart';
import 'package:r411alto/widgets/common/NavItem.dart';

class FloatingBar extends StatefulWidget {

  const FloatingBar({
    super.key,
  });

  @override
  State<FloatingBar> createState() => _FloatinBar();
}

class _FloatinBar extends State<FloatingBar> {

  bool addIsActivated = false;

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
              IconButton(icon: Icon(Icons.add), onPressed: changeState,),
              NavItem(icon: Icons.house, name: "home"),
              NavItem(icon: Icons.account_circle, name: "profil"),
            ],
          ),
        ),
      ),
    );

  }

  void changeState() {
    this.addIsActivated = !this.addIsActivated;
  }

  

}
