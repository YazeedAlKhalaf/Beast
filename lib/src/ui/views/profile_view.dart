import 'package:beast/src/constants/config.dart';
import 'package:beast/src/viewmodels/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider.withConsumer(
      viewModel: ProfileViewModel(),
      onModelReady: (ProfileViewModel model) => model.initStateFunc(
        contextFromFunc: context,
      ),
      builder: (
        BuildContext context,
        ProfileViewModel model,
        Widget child,
      ) {
        return Scaffold(
          backgroundColor: Config.blackColor,
          appBar: model.customAppBar(),
          body: model.buildBody(),
        );
      },
    );
  }
}
