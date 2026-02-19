import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:r411alto/widgets/common/HeaderAccount.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
  static const String _rickRollUrl = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';

  Future<void> _launchRickRoll() async {
    final Uri url = Uri.parse(_rickRollUrl);
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open the Rick Roll!'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( // pour éviter les encoches
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // aligne à gauche
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // retour à la page précédente
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Headeraccount(
                    user_name: "Other user name"
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
