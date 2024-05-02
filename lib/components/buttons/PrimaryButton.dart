import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  bool loading;
  Color? textColor;
  Color? buttonColor;
  PrimaryButton({super.key, required this.title, required this.onPressed, this.loading = false, this.textColor, this.buttonColor });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      // width: MediaQuery.of(context).size.width * 0.5,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
            // backgroundColor: Colors.pink,
            backgroundColor: buttonColor ?? const Color(0xfffc3b77),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        child: Text(
          title,
          style: TextStyle(fontSize: 18, color: textColor),
        ),
      ),
    );
  }
}
