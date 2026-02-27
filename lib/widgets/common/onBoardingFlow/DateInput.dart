import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInput extends StatefulWidget {
  final String label;
  final bool isRequired;

  const DateInput({
    super.key,
    required this.label,
    required this.isRequired,
  });

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {

  final TextEditingController _controller = TextEditingController();
  DateTime? selectedDate;

  Future<void> _pickDate() async {

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// LABEL
        Text.rich(
          TextSpan(
            text: widget.label[0].toUpperCase() + widget.label.substring(1),
            style: const TextStyle(fontSize: 16),
            children: widget.isRequired
                ? const [
              TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              )
            ]
                : [],
          ),
        ),

        const SizedBox(height: 6),

        /// INPUT
        TextFormField(
          controller: _controller,
          readOnly: true,
          onTap: _pickDate,
          decoration: const InputDecoration(
            hintText: "Select a date",
            border: UnderlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
        ),
      ],
    );
  }
}
