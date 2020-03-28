import 'package:beast/src/constants/config.dart';
import 'package:beast/src/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class AddButton extends StatefulWidget {
  final bool isAdded;
  final GestureTapCallback onTap;

  AddButton({
    @required this.isAdded,
    this.onTap,
  });

  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: Config.fabGradient,
          borderRadius: BorderRadius.circular(
            50,
          ),
        ),
        child: Icon(
          widget.isAdded ? Icons.close : Icons.add,
          color: Config.whiteColor,
          size: screenWidth(context) * 0.06,
        ),
        padding: EdgeInsets.all(
          screenWidth(context) * 0.03,
        ),
      ),
    );
  }
}
