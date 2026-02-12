
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r411alto/widgets/common/FloatingBar.dart';


class MainFormScreen extends StatefulWidget {
  const MainFormScreen({super.key, required this.title});

  final String title;

  @override
  State<MainFormScreen> createState() => _MainFormScreen();
}

class _MainFormScreen extends State<MainFormScreen> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

        ],
      ),
    );
  }
}
