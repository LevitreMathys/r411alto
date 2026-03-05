import 'package:flutter/material.dart';
import 'package:r411alto/widgets/common/HeaderHomeScreen.dart';


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
            /*Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Headerhomescreen()
            ),*/
            // Text centré
            Center(
              child: Text(
                  "Aucune connexion établie"
              ),
            ),
          ],
      ),
    );
  }
}