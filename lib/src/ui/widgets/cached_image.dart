import 'package:beast/src/app/constants/config.dart';
import 'package:beast/src/ui/global/ui_helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String url;
  final GestureTapCallback onTap;

  CachedImage({
    @required this.url,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: screenWidth(context) * 0.65,
        height: screenWidth(context) * 0.65,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            screenWidth(context) * 0.015,
          ),
          child: CachedNetworkImage(
              imageUrl: url,
              placeholder: (BuildContext context, String url) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                      Config.lightBlueColor,
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
