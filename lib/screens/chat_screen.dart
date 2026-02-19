import 'package:flutter/material.dart';
import 'package:r411alto/widgets/common/HeaderAccount.dart';
import 'package:r411alto/widgets/common/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {

  final List<Map<String, dynamic>> messages = [];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();



  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      messages.add({"text": _controller.text.trim(), "isMe": true});
    });

    _controller.clear();

    // Scroll vers le bas
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
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
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return Message(
                    text: msg['text'],
                    isMe: msg['isMe'],
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter your message',
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                  ),
                  suffixIcon: IconButton(
                      onPressed: _sendMessage,
                      icon: Icon(Icons.send)
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
