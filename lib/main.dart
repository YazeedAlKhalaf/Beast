import 'package:beast/src/constants/config.dart';
import 'package:beast/src/locator.dart';
import 'package:beast/src/managers/dialog_manager.dart';
import 'package:beast/src/services/dialog_service.dart';
import 'package:beast/src/services/navigation_service.dart';
import 'package:beast/src/ui/router.dart';
import 'package:beast/src/ui/views/startup_view.dart';
import 'package:flutter/material.dart';

void main() {
  // Register all the models and services before the app starts
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beast',
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => DialogManager(child: child),
        ),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Config.blackColor,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Open Sans',
            ),
      ),
      home: StartUpView(),
      onGenerateRoute: generateRoute,
    );
  }
}
