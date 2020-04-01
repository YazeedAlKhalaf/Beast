import 'package:beast/src/constants/config.dart';
import 'package:beast/src/constants/route_names.dart';
import 'package:beast/src/constants/strings.dart';
import 'package:beast/src/models/chat.dart';
import 'package:beast/src/models/message.dart';
import 'package:beast/src/models/user.dart';
import 'package:beast/src/ui/shared/ui_helpers.dart';
import 'package:beast/src/ui/widgets/custom_app_bar.dart';
import 'package:beast/src/ui/widgets/custom_tile.dart';
import 'package:beast/src/ui/widgets/user_circle.dart';
import 'package:beast/src/viewmodels/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatsViewModel extends BaseModel {
  initStateFunc({
    BuildContext contextFromFunc,
  }) {
    getContext(
      contextFromFunc: contextFromFunc,
    );
  }

  BuildContext context;

  getContext({
    BuildContext contextFromFunc,
  }) {
    context = contextFromFunc;
    notifyListeners();
  }

  getLastMessage(Chat chat) {
    Message lastMessage =
        chat.messages.length > 0 ? chat.messages.last : Message();

    decideType() {
      switch (lastMessage.type) {
        case TEXT_MESSAGE_TYPE:
          return Text(
            lastMessage.message,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Config.greyColor,
              fontSize: screenWidth(context) * 0.035,
            ),
          );
          break;
        case IMAGE_MESSAGE_TYPE:
          return Text(
            'Photo 📸',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Config.greyColor,
              fontSize: screenWidth(context) * 0.035,
            ),
          );
          break;
        case VIDEO_MESSAGE_TYPE:
          return Text(
            'Vedio 🎥',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Config.greyColor,
              fontSize: screenWidth(context) * 0.035,
            ),
          );
          break;
        default:
          return Text(
            '',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Config.greyColor,
              fontSize: screenWidth(context) * 0.035,
            ),
          );
      }
    }

    decideSender() {
      if (lastMessage.senderId == currentUser.uid) {
        return Text(
          'You: ',
          style: TextStyle(
            color: Config.greyColor,
            fontSize: screenWidth(context) * 0.035,
          ),
        );
      } else if (lastMessage.senderId == chat.receiver.uid) {
        return Text(
          chat.receiver.fullName.split(' ').first,
          style: TextStyle(
            color: Config.greyColor,
            fontSize: screenWidth(context) * 0.035,
          ),
        );
      }

      return Text('');
    }

    return Row(
      children: <Widget>[
        decideSender(),
        decideType(),
      ],
    );
  }

  buildChatsList() {
    return StreamBuilder(
      stream: firestoreService.chatsStream(sender: currentUser),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data == null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(
                screenWidth(context) * 0.03,
              ),
              child: Text(
                'Check your interent connection',
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Config.whiteColor,
                  fontSize: screenWidth(context) * 0.05,
                ),
              ),
            ),
          );
        }

        if (snapshot.data.documents.length == 0) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(
                screenWidth(context) * 0.03,
              ),
              child: Text(
                'Add Some Friends\n\nYou can add friends by searching for them in the search screen',
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Config.whiteColor,
                  fontSize: screenWidth(context) * 0.05,
                ),
              ),
            ),
          );
        }

        return Container(
          child: ListView.builder(
            reverse: false,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              Chat chat = Chat.fromJson(snapshot.data.documents[index].data);
              return Padding(
                padding: EdgeInsets.all(
                  screenWidth(context) * 0.025,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      screenWidth(context) * 0.05,
                    ),
                  ),
                  color: Config.senderColor,
                  child: CustomTile(
                    margin: EdgeInsets.all(screenWidth(context) * 0.02),
                    mini: false,
                    onTap: () {
                      navigateToChatView(
                        receiver: chat.receiver,
                      );
                    },
                    title: Text(
                      chat.receiver.fullName,
                      style: TextStyle(
                        color: Config.whiteColor,
                        fontSize: screenWidth(context) * 0.05,
                      ),
                    ),
                    subtitle: getLastMessage(chat),
                    leading: UserCircle(
                      width: screenWidth(context) * 0.1,
                      height: screenWidth(context) * 0.1,
                      textSize: screenWidth(context) * 0.035,
                      text: utils.getInitials(
                        chat.receiver.fullName,
                      ),
                      image: displayProfileImage(
                        user: chat.receiver,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  customAppBar() {
    return CustomAppBar(
      centerTitle: true,
      title: UserCircle(
        width: screenWidth(context) * 0.1,
        height: screenWidth(context) * 0.1,
        textSize: screenWidth(context) * 0.035,
        text: userInitials,
        image: displayProfileImage(
          user: currentUser,
        ),
        onTap: () {
          print(userInitials);
          navigateToProfileView();
        },
      ),
    );
  }

  navigateToChatView({
    User receiver,
  }) {
    navigationService.navigateTo(
      ChatViewRoute,
      arguments: receiver,
    );
  }

  navigateToProfileView() {
    navigationService.navigateTo(ProfileViewRoute);
  }
}
