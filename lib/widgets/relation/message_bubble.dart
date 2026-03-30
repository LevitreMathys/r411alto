import 'package:flutter/material.dart';
import '../../models/element.dart' as model_element;
import '../../models/pairing.dart';

class MessageBubble extends StatelessWidget {
  final model_element.Element element;
  final Relation relation;
  final bool isOwnMessage;

  const MessageBubble({
    super.key,
    required this.element,
    required this.relation,
    required this.isOwnMessage,
  });

  @override
  Widget build(BuildContext context) {
    final decryptedText = relation.decryptMessage(element.value);
    return Align(
      alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isOwnMessage ? const Color(0xFF1E3A8A) : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: isOwnMessage
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              decryptedText,
              style: TextStyle(
                color: isOwnMessage ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              element.timestamp.toString().substring(11, 16),
              style: TextStyle(
                color: isOwnMessage ? Colors.white70 : Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
