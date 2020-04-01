import 'package:beast/src/constants/config.dart';
import 'package:beast/src/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class TextLink extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color;
  const TextLink(
    this.text, {
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        text,
        overflow: TextOverflow.clip,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: screenWidth(context) * 0.04,
        ),
      ),
    );
  }
}
