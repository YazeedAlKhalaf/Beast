import 'package:beast/src/app/constants/config.dart';
import 'package:beast/src/app/constants/strings.dart';
import 'package:beast/src/app/models/chat.dart';
import 'package:beast/src/app/models/message.dart';
import 'package:beast/src/ui/global/app_colors.dart';
import 'package:beast/src/ui/global/ui_helpers.dart';
import 'package:beast/src/ui/views/chats/chats_view_model.dart';
import 'package:beast/src/ui/widgets/busy_overlay.dart';
import 'package:beast/src/ui/widgets/custom_app_bar.dart';
import 'package:beast/src/ui/widgets/custom_tile.dart';
import 'package:beast/src/ui/widgets/user_circle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      builder: (
        BuildContext context,
        ChatsViewModel model,
        Widget child,
      ) {
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
                    fontSize: blockSizeHorizontal(context) * 3.5,
                  ),
                );
                break;
              case IMAGE_MESSAGE_TYPE:
                return Text(
                  'Photo 📸',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Config.greyColor,
                    fontSize: blockSizeHorizontal(context) * 3.5,
                  ),
                );
                break;
              case VIDEO_MESSAGE_TYPE:
                return Text(
                  'Video 🎥',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Config.greyColor,
                    fontSize: blockSizeHorizontal(context) * 3.5,
                  ),
                );
                break;
              default:
                return Text(
                  '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Config.greyColor,
                    fontSize: blockSizeHorizontal(context) * 3.5,
                  ),
                );
            }
          }

          decideSender() {
            if (lastMessage.senderId == model.currentUser.uid) {
              return Text(
                'You: ',
                style: TextStyle(
                  color: Config.greyColor,
                  fontSize: blockSizeHorizontal(context) * 3.5,
                ),
              );
            } else if (lastMessage.senderId == chat.receiver.uid) {
              return Text(
                '${chat.receiver.fullName.split(' ').first}: ',
                style: TextStyle(
                  color: Config.greyColor,
                  fontSize: blockSizeHorizontal(context) * 3.5,
                ),
              );
            }
          }

          return Row(
            children: <Widget>[
              decideSender(),
              decideType(),
            ],
          );
        }

        return BusyOverlay(
          show: model.isBusy,
          child: Scaffold(
            appBar: CustomAppBar(
              centerTitle: true,
              title: UserCircle(
                width: blockSizeHorizontal(context) * 10,
                height: blockSizeHorizontal(context) * 10,
                textSize: blockSizeHorizontal(context) * 3.5,
                text: model.userInitials,
                image: model.displayProfileImage(
                  user: model.currentUser,
                ),
                onTap: () {
                  print(model.userInitials);
                  model.navigateToProfileView();
                },
              ),
            ),
            body: StreamBuilder(
              stream: model.chatsStream(),
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data == null) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(
                        blockSizeHorizontal(context) * 0.3,
                      ),
                      child: Text(
                        'Check your interent connection',
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Config.whiteColor,
                          fontSize: blockSizeHorizontal(context) * 4,
                        ),
                      ),
                    ),
                  );
                }

                if (snapshot.data.documents.length == 0) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(
                        blockSizeHorizontal(context) * 4,
                      ),
                      child: Text(
                        'Add Some Friends\n\nYou can add friends by searching for them in the search screen',
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textColorBlack,
                          fontSize: blockSizeHorizontal(context) * 4,
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
                      Chat chat = Chat.fromJson(
                        snapshot.data.documents[index].data,
                      );
                      return Card(
                        margin: EdgeInsets.all(
                          blockSizeHorizontal(context) * 5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: primaryColor,
                        child: CustomTile(
                          margin: EdgeInsets.all(
                            blockSizeHorizontal(context) * 2.5,
                          ),
                          mini: false,
                          onTap: () {
                            model.navigateToChatView(
                              receiver: chat.receiver,
                            );
                          },
                          title: Text(
                            chat.receiver.fullName,
                            style: TextStyle(
                              color: Config.whiteColor,
                              fontSize: blockSizeHorizontal(context) * 5,
                            ),
                          ),
                          subtitle: getLastMessage(chat),
                          leading: UserCircle(
                            width: blockSizeHorizontal(context) * 10,
                            height: blockSizeHorizontal(context) * 10,
                            textSize: blockSizeHorizontal(context) * 3.5,
                            text:
                                model.utils.getInitials(chat.receiver.fullName),
                            image: model.displayProfileImage(
                              user: chat.receiver,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
