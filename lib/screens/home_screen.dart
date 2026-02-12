
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r411alto/widgets/common/FloatingBar.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
          children: [

            // Text centré
            Center(
              child: Text(
                  "Aucune connexion établie"
              ),
            ),

            Positioned(
                bottom: 0,
                left: 0,
                child:
                IgnorePointer(child:
                  Image(
                    image: AssetImage(
                        "assets/images/Group14.png"
                    )
                  )
                ),
            ),




            FloatingBar()




          ],
      ),
    );
  }
}