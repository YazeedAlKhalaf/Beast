import 'package:beast/src/constants/config.dart';
import 'package:beast/src/ui/shared/ui_helpers.dart';
import 'package:beast/src/ui/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final GestureTapCallback onTap;

  const ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth(context) * 0.035,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: CustomTile(
          mini: false,
          leading: Container(
            margin: EdgeInsets.only(
              right: screenWidth(context) * 0.02,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                screenWidth(context) * 0.03,
              ),
              color: Config.receiverColor,
            ),
            padding: EdgeInsets.all(
              screenWidth(context) * 0.02,
            ),
            child: Icon(
              icon,
              color: Config.greyColor,
              size: screenWidth(context) * 0.08,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: Config.greyColor,
              fontSize: screenWidth(context) * 0.035,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: screenWidth(context) * 0.045,
            ),
          ),
        ),
      ),
    );
  }
}
