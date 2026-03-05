import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PopUpAlert extends StatelessWidget {

  final bool isErr;
  final String content;

  const PopUpAlert({
    super.key,
    required this.isErr,
    required this.content
  });

  @override
  Widget build(BuildContext context) {

    final Color color;

    if (this.isErr) color = Color.fromRGBO(255, 0, 0, .8);
    else color = Color.fromRGBO(0, 255, 0, 1);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30)
      ),
      child: Text(
        this.content,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold
        ),
      ),
    ).animate()

    .slideY(
      begin: -1,
      end: 0,
      duration: 400.ms,
      curve: Curves.easeOut,
    )

    .then(delay: 1.seconds)

    .slideY(
      begin: 0,
      end: -1,
      duration: 400.ms,
      curve: Curves.easeIn,
    )
    
    .fadeOut(duration: 300.ms);
  }

}

