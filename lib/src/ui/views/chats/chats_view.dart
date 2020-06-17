import 'package:beast/src/app/constants/config.dart';
import 'package:beast/src/ui/views/chats/chats_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ChatsView extends StatefulWidget {
  @override
  _ChatsViewState createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatsViewModel>.reactive(
      viewModelBuilder: () => ChatsViewModel(),
      onModelReady: (ChatsViewModel model) => model.initStateFunc(
        contextFromFunc: context,
      ),
      builder: (
        BuildContext context,
        ChatsViewModel model,
        Widget child,
      ) {
        return Scaffold(
          backgroundColor: Config.blackColor,
          appBar: model.customAppBar(),
          body: model.buildChatsList(),
        );
      },
    );
  }
}
