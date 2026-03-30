import 'package:flutter/material.dart';

class EmojiPickerWidget extends StatefulWidget {
  final Function(String) onEmojiSelected;

  const EmojiPickerWidget({super.key, required this.onEmojiSelected});

  @override
  State<EmojiPickerWidget> createState() => _EmojiPickerWidgetState();
}

class _EmojiPickerWidgetState extends State<EmojiPickerWidget> {
  final List<String> emojis = [
    '😀',
    '😂',
    '😍',
    '🤔',
    '😎',
    '🥳',
    '😢',
    '😡',
    '👍',
    '❤️',
    '🔥',
    '⭐',
    '🚀',
    '💯',
    '👏',
    '🙌',
    '🤝',
    '✨',
    '🎉',
    '📱',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choisir un emoji'),
      content: SizedBox(
        width: double.maxFinite,
        height: 200,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            childAspectRatio: 1.2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: emojis.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                widget.onEmojiSelected(emojis[index]);
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Text(
                    emojis[index],
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fermer'),
        ),
      ],
    );
  }
}
