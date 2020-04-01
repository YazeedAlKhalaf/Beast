import 'package:beast/src/constants/config.dart';
import 'package:beast/src/ui/widgets/new_chat_fab.dart';
import 'package:beast/src/viewmodels/chats_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class ChatsView extends StatefulWidget {
  @override
  _ChatsViewState createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider.withConsumer(
      viewModel: ChatsViewModel(),
      onModelReady: (model) => model.initStateFunc(
        contextFromFunc: context,
      ),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Config.blackColor,
          appBar: model.customAppBar(),
          // floatingActionButton: NewChatFab(
          //   onTap: () {
          //     print('Searching for users to chat with');
          //     model.navigateToSearchView();
          //   },
          // ),
          body: model.buildChatsList(),
        );
      },
    );
  }
}
