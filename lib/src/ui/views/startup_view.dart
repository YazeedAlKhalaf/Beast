import 'package:beast/src/constants/config.dart';
import 'package:beast/src/ui/shared/ui_helpers.dart';
import 'package:beast/src/viewmodels/startup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class StartUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<StartUpViewModel>.withConsumer(
      viewModel: StartUpViewModel(),
      onModelReady: (model) => model.handleStartUpLogic(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Config.blackColor,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: screenWidth(context) * 0.25,
                  height: screenWidth(context) * 0.25,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/icon_large.png',
                    ),
                  ),
                ),
                SizedBox(
                  height: screenWidth(context) * 0.1,
                ),
                CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation(
                    Color(0xff19c7c1),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
