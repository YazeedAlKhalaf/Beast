import 'package:beast/src/constants/config.dart';
import 'package:beast/src/models/user.dart';
import 'package:beast/src/ui/widgets/custom_app_bar.dart';
import 'package:beast/src/viewmodels/user_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

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
    return ViewModelProvider.withConsumer(
      viewModel: UserDetailsViewModel(),
      onModelReady: (model) => model.initStateFunc(
        contextFromFunc: context,
        receiverFromFunc: widget.receiver,
      ),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Config.blackColor,
          appBar: model.customAppBar(),
          body: model.buildBody(),
        );
      },
    );
  }
}
