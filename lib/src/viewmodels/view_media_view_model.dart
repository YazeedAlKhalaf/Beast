import 'package:beast/src/constants/config.dart';
import 'package:beast/src/models/chat.dart';
import 'package:beast/src/models/message.dart';
import 'package:beast/src/models/user.dart';
import 'package:beast/src/ui/shared/ui_helpers.dart';
import 'package:beast/src/ui/widgets/cached_image.dart';
import 'package:beast/src/ui/widgets/custom_app_bar.dart';
import 'package:beast/src/viewmodels/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewMediaViewModel extends BaseModel {
  User receiver;

  static int initialPage = 0;
  PageController pageController = PageController(
    initialPage: initialPage,
  );

  BuildContext context;

  initState({
    @required User receiverFromFunc,
    @required BuildContext contextFromFunc,
  }) {
    getVariables(
      receiverFromFunc: receiverFromFunc,
      contextFromFunc: contextFromFunc,
    );
  }

  getVariables({
    @required User receiverFromFunc,
    @required BuildContext contextFromFunc,
  }) {
    receiver = receiverFromFunc;
    context = contextFromFunc;
    notifyListeners();
  }

  customAppBar() {
    return CustomAppBar(
      title: Text('Media'),
    );
  }

  buildBody() {
    return StreamBuilder(
      stream: firestoreService.chatsStream(
        sender: currentUser,
        receiver: receiver,
      ),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                Config.lightBlueColor,
              ),
            ),
          );
        }

        return PageView.builder(
          itemCount: snapshot.data.data.length == 1
              ? snapshot.data.data.length - 2
              : snapshot.data.data.length,
          itemBuilder: (BuildContext context, int index) {
            Chat chat = Chat.fromJson(snapshot.data.data);
            List<Message> messages = chat.messages;
            List<Message> messagesWithMedia = messages;
            messagesWithMedia.removeWhere(
              (message) => message.mediaUrls.length == 0,
            );

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return PageView.builder(
              controller: pageController,
              itemCount: messagesWithMedia.length,
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: Container(
                    width: screenWidth(context),
                    child: CachedImage(
                      url: messagesWithMedia[index].mediaUrls[0],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
