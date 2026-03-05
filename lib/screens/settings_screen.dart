import 'package:flutter/material.dart';
import 'package:r411alto/widgets/common/HeaderHomeScreen.dart';
import 'package:r411alto/widgets/common/AddButtons.dart';
import 'package:r411alto/widgets/common/FloatingBar.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.title});
  final String title;

  @override
  State<SettingsScreen> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Text("Settings screen"),

        ]
      )
    );
  }
}