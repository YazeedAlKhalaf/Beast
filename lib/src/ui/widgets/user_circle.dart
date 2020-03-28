import 'package:beast/src/constants/config.dart';
import 'package:flutter/material.dart';

class UserCircle extends StatelessWidget {
  final String text;
  final Widget image;
  final double width;
  final double height;
  final double textSize;
  final GestureTapCallback onTap;

  UserCircle({
    @required this.text,
    this.image,
    @required this.width,
    @required this.height,
    @required this.textSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Config.separatorColor,
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: image != null
                  ? ClipOval(
                      child: image,
                    )
                  : Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Config.lightBlueColor,
                        fontSize: textSize,
                      ),
                    ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: width * 0.3,
                height: width * 0.3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Config.blackColor,
                    width: 2,
                  ),
                  color: Config.onlineDotColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
