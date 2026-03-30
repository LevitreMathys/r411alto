import 'package:flutter/material.dart';
import '../../../models/element.dart';

class TypeSelector extends StatefulWidget {
  final Function(ElementType) onTypeChanged;

  const TypeSelector({super.key, required this.onTypeChanged});

  @override
  State<TypeSelector> createState() => _TypeSelectorState();
}

class _TypeSelectorState extends State<TypeSelector> {
  ElementType selectedType = ElementType.message;

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(8),
      selectedBorderColor: Colors.blue,
      fillColor: Colors.blue,
      selectedColor: Colors.white,
      isSelected: [
        selectedType == ElementType.message,
        selectedType == ElementType.color,
        selectedType == ElementType.icon,
      ],
      onPressed: (index) {
        final newType = ElementType.values[index];
        setState(() => selectedType = newType);
        widget.onTypeChanged(newType);
      },
      children: const [
        Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.message)),
        Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.color_lens)),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.emoji_emotions),
        ),
      ],
    );
  }
}
