import 'package:beast/src/app/constants/config.dart';
import 'package:beast/src/app/models/user.dart';
import 'package:beast/src/ui/views/user_details/user_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class UserDetailsView extends StatefulWidget {
  final User receiver;

  UserDetailsView({
    this.receiver,
  });
  @override
  _UserDetailsViewState createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserDetailsViewModel>.reactive(
      viewModelBuilder: () => UserDetailsViewModel(),
      onModelReady: (UserDetailsViewModel model) => model.initStateFunc(
        contextFromFunc: context,
        receiverFromFunc: widget.receiver,
      ),
      builder: (
        BuildContext context,
        UserDetailsViewModel model,
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
