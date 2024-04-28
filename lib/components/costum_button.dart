import 'package:flutter/material.dart';

class CostumButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double padding;
  final double margin;
  final double textSize;

  const CostumButton(
      {super.key,
      required this.onTap,
      required this.buttonText,
      required this.buttonColor,
      required this.textColor,
      required this.padding,
      required this.margin,
      required this.textSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        margin: EdgeInsets.symmetric(horizontal: margin),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.normal,
              fontSize: textSize,
            ),
          ),
        ),
      ),
    );
  }
}
