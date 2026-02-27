import 'package:flutter/material.dart';

class ProfilSettingScreen extends StatelessWidget {
  const ProfilSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Setting'),
      ),
      body: Column(
        children: [

          Positioned(

              child: Icon(Icons.account_circle, size: 200),

          ),
        ],
      ),
    );
  }
}

