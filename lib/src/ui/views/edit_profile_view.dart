import 'package:beast/src/constants/config.dart';
import 'package:beast/src/viewmodels/edit_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider.withConsumer(
      viewModel: EditProfileViewModel(),
      onModelReady: (EditProfileViewModel model) => model.initStateFunc(
        contextFromFunc: context,
      ),
      builder: (
        BuildContext context,
        EditProfileViewModel model,
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
