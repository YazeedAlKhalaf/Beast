import 'package:beast/src/app/constants/config.dart';
import 'package:beast/src/app/models/user.dart';
import 'package:beast/src/ui/views/view_media/view_media_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

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
    return ViewModelBuilder<ViewMediaViewModel>.reactive(
      viewModelBuilder: () => ViewMediaViewModel(),
      onModelReady: (ViewMediaViewModel model) => model.initState(
        receiverFromFunc: widget.receiver,
        contextFromFunc: context,
      ),
      builder: (
        BuildContext context,
        ViewMediaViewModel model,
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
