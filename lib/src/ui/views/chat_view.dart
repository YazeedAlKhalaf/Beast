import 'package:beast/src/constants/config.dart';
import 'package:beast/src/models/user.dart';
import 'package:beast/src/viewmodels/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

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
    return ViewModelProvider.withConsumer(
      viewModel: ChatViewModel(),
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
