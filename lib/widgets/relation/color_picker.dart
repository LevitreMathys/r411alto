import 'package:flutter/material.dart';

class ColorPickerWidget extends StatelessWidget {
  final Function(String) onColorSelected;

  const ColorPickerWidget({super.key, required this.onColorSelected});

  static const List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.cyan,
    Colors.amber,
    Colors.brown,
    Colors.grey,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choisir une couleur'),
      content: SizedBox(
        width: double.maxFinite,
        height: 200,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: colors.length,
          itemBuilder: (context, index) {
            final color = colors[index];
            return GestureDetector(
              onTap: () {
                final hex = '#\${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
                onColorSelected(hex);
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
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
