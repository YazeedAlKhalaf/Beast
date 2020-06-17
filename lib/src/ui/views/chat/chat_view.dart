import 'package:beast/src/app/constants/config.dart';
import 'package:beast/src/app/models/user.dart';
import 'package:beast/src/ui/views/chat/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ChatView extends StatefulWidget {
  final User receiver;

  ChatView({
    this.receiver,
  });

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatViewModel>.reactive(
      viewModelBuilder: () => ChatViewModel(),
      onModelReady: (ChatViewModel model) => model.initStateFunc(
        contextFromFunc: context,
        receiverFromFunc: widget.receiver,
      ),
      builder: (
        BuildContext context,
        ChatViewModel model,
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
