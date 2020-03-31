import 'package:beast/src/constants/config.dart';
import 'package:beast/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:beast/src/viewmodels/view_media_view_model.dart';

class ViewMediaView extends StatefulWidget {
  final User receiver;

  ViewMediaView({
    this.receiver,
  });
  @override
  _ViewMediaViewState createState() => _ViewMediaViewState();
}

class _ViewMediaViewState extends State<ViewMediaView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider.withConsumer(
      viewModel: ViewMediaViewModel(),
      onModelReady: (model) => model.initState(
        receiverFromFunc: widget.receiver,
        contextFromFunc: context,
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
