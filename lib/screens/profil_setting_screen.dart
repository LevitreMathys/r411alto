import 'package:flutter/material.dart';

class ProfilSettingScreen extends StatelessWidget {
  const ProfilSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Setting'),
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.account_circle,
                  size: 150,
                ),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: ElevatedButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                Text("Edit profile"),
                                SizedBox(width: 10,),
                                Icon(Icons.edit)
                              ],
                            )
                        ),
                    )
                  ],
                )
              ],
            )
          )
        ],
      ),
    );
  }
}

