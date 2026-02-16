import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:r411alto/widgets/common/onBoardingFlow/Input.dart';

import 'DateInput.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {

  List<DateTime?> _date = []; // IMPORTANT: CalendarDatePicker2 utilise une LISTE

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          child: Column(
            children: [

              /// FIRST + LAST NAME
              Row(
                children: [
                  Expanded(
                    child: Input(
                      label: "firstname",
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 12), // espace entre les 2 inputs
                  Expanded(
                    child: Input(
                      label: "lastname",
                      isRequired: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              DateInput(
                label: "date of birth",
                isRequired: true,
              ),

              const SizedBox(height: 20),
              Input(
                label: "email",
                isRequired: true,
              ),

              const SizedBox(height: 20),
              Input(
                label: "password",
                isRequired: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
