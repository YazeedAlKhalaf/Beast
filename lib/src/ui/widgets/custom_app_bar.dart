import 'package:beast/src/app/constants/config.dart';
import 'package:beast/src/ui/global/app_colors.dart';
import 'package:beast/src/ui/global/ui_helpers.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  CustomAppBar({
    @required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        screenWidth(context) * 0.02,
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        border: Border(
          bottom: BorderSide(
            color: Config.separatorColor,
            width: 1.4,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: leading != null ? leading : null,
        title: title,
        centerTitle: centerTitle,
        actions: actions != null ? actions : <Widget>[],
      ),
    );
  }
}
