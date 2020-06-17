import 'package:beast/src/app/constants/config.dart';
import 'package:beast/src/ui/global/ui_helpers.dart';
import 'package:flutter/material.dart';

class NewChatFab extends StatelessWidget {
  final GestureTapCallback onTap;

  NewChatFab({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: Config.fabGradient,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: screenWidth(context) * 0.07,
        ),
        padding: EdgeInsets.all(
          screenWidth(context) * 0.035,
        ),
      ),
    );
  }
}
