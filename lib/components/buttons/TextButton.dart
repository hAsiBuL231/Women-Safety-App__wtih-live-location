import 'package:flutter/material.dart';

class SecondaryTextButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  const SecondaryTextButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
          onPressed: () {
            onPressed();
          },
          child: Text(title, style: const TextStyle(fontSize: 18))),
    );
  }
}
