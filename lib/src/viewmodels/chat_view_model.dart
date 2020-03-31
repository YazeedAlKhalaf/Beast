import 'dart:io';

import 'package:beast/src/constants/config.dart';
import 'package:beast/src/constants/route_names.dart';
import 'package:beast/src/constants/strings.dart';
import 'package:beast/src/models/message.dart';
import 'package:beast/src/models/user.dart';
import 'package:beast/src/ui/shared/ui_helpers.dart';
import 'package:beast/src/ui/widgets/cached_image.dart';
import 'package:beast/src/ui/widgets/custom_app_bar.dart';
import 'package:beast/src/ui/widgets/modal_tile.dart';
import 'package:beast/src/viewmodels/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ChatViewModel extends BaseModel {
  initStateFunc({
    @required BuildContext contextFromFunc,
    @required User receiverFromFunc,
  }) {
    getVariables(
      contextFromFunc: contextFromFunc,
      receiverFromFunc: receiverFromFunc,
    );
  }

  TextEditingController textFieldController = TextEditingController();

  Message message;

  List<String> mediaUrls = [];

  bool isWriting = false;

  void setWriting(bool value) {
    isWriting = value;
    notifyListeners();
  }

  BuildContext context;
  User receiver;

  getVariables({
    @required BuildContext contextFromFunc,
    @required User receiverFromFunc,
  }) {
    context = contextFromFunc;
    receiver = receiverFromFunc;
    notifyListeners();
  }

  CustomAppBar customAppBar() {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Config.whiteColor,
        ),
        onPressed: () => popCurrentContext(),
      ),
      centerTitle: false,
      title: Text(
        receiver.fullName,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.info_outline,
            color: Config.whiteColor,
          ),
          onPressed: () {
            navigationService.navigateTo(
              UserDetailsViewRoute,
              arguments: receiver,
            );
          },
        ),
      ],
    );
  }

  sendMessage() async {
    var text = textFieldController.text;
    textFieldController.clear();

    setWriting(false);
    setBusy(true);

    await firestoreService.addMessageToDb(
      sender: currentUser,
      receiver: receiver,
      text: text,
      messageType: TEXT_MESSAGE_TYPE,
    );

    setBusy(false);
  }

  pickImage({
    @required ImageSource source,
  }) async {
    popCurrentContext();
    File selectedImage = await utils.pickImage(
      source: source,
    );

    if (selectedImage != null) {
      setBusy(true);

      await storageService.uploadMedia(
        media: [
          selectedImage,
        ],
        receiver: receiver,
        sender: currentUser,
        messageType: IMAGE_MESSAGE_TYPE,
      );

      setBusy(false);
    } else {
      print('there was an error');
    }
  }

  pickVideo({
    @required ImageSource source,
  }) async {
    popCurrentContext();
    File selectedVideo = await utils.pickVideo(
      source: source,
    );

    if (selectedVideo != null) {
      setBusy(true);

      await storageService.uploadMedia(
        media: [
          selectedVideo,
        ],
        receiver: receiver,
        sender: currentUser,
        messageType: VIDEO_MESSAGE_TYPE,
      );

      setBusy(false);
    } else {
      dialogService.showDialog(
        title: 'Something went wrong!',
        description: 'Please try again later!',
      );
    }
  }

  buildBody() {
    return Column(
      children: <Widget>[
        busy
            ? LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  Config.lightBlueColor,
                ),
              )
            : Container(),
        Flexible(
          child: messageList(),
        ),
        chatControls(),
      ],
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: firestoreService.messagesStream(
        sender: currentUser,
        receiver: receiver,
      ),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                Config.lightBlueColor,
              ),
            ),
          );
        }

        return ListView.builder(
          reverse: true,
          padding: EdgeInsets.all(
            screenWidth(context) * 0.025,
          ),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int index) {
            message = Message.fromJson(snapshot.data.documents[index].data);

            return chatMessageItem();
          },
        );
      },
    );
  }

  Widget chatMessageItem() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenWidth(context) * 0.035,
      ),
      child: Container(
        alignment: message.senderId == currentUser.uid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: message.senderId == currentUser.uid
            ? senderLayout()
            : receiverLayout(),
      ),
    );
  }

  Widget senderLayout() {
    Radius messageRadius = Radius.circular(
      screenWidth(context) * 0.02,
    );

    return Container(
      margin: EdgeInsets.only(
        top: screenWidth(context) * 0.035,
      ),
      constraints: BoxConstraints(
        maxWidth: screenWidth(context) * 0.65,
      ),
      decoration: BoxDecoration(
        color: Config.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          screenWidth(context) * 0.025,
        ),
        child: getMessage(),
      ),
    );
  }

  getMessage() {
    switch (message.type) {
      case TEXT_MESSAGE_TYPE:
        return Text(
          message.message,
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth(context) * 0.035,
          ),
        );
        break;

      case IMAGE_MESSAGE_TYPE:
        return GestureDetector(
          onTap: () {
            if (message.mediaUrls.length != 0) {
              mediaUrls = message.mediaUrls;
            }
            navigateToViewMediaView();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: screenWidth(context) * 0.4,
                    ),
                    decoration: BoxDecoration(
                      color: Config.separatorColor,
                    ),
                    child: CachedImage(
                      url: message.mediaUrls[0],
                      onTap: () {
                        print('This is an image. URL: ${message.mediaUrls}');
                      },
                    ),
                  ),
                  Opacity(
                    opacity: message.mediaUrls.length > 1 ? 0.5 : 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Config.separatorColor,
                      ),
                      height: screenWidth(context) * 0.4,
                    ),
                  ),
                  Opacity(
                    opacity: message.mediaUrls.length > 1 ? 1 : 0,
                    child: Text(
                      '+${(message.mediaUrls.length - 1).toString()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth(context) * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              message.message != ''
                  ? Text(
                      message.message,
                      style: TextStyle(
                        fontSize: screenWidth(context) * 0.04,
                        color: Config.whiteColor,
                      ),
                      overflow: TextOverflow.clip,
                    )
                  : Container(),
            ],
          ),
        );
        break;

      // case VIDEO_MESSAGE_TYPE:
      //   return message.mediaUrls.length > 0
      //       ? VideoPlayer(
      //           VideoPlayerController.network(
      //             message.mediaUrls[0],
      //           ),
      //         )
      //       : Text('No Media Found');
      //   break;

      default:
        return Text(
          'Error fetching',
          style: TextStyle(
            fontSize: screenWidth(context) * 0.04,
            color: Config.whiteColor,
          ),
          overflow: TextOverflow.clip,
        );
    }
  }

  Widget receiverLayout() {
    Radius messageRadius = Radius.circular(
      screenWidth(context) * 0.025,
    );

    return Container(
      margin: EdgeInsets.only(
        top: screenWidth(context) * 0.035,
      ),
      constraints: BoxConstraints(
        maxWidth: screenWidth(context) * 0.65,
      ),
      decoration: BoxDecoration(
        color: Config.receiverColor,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          screenWidth(context) * 0.025,
        ),
        child: getMessage(),
      ),
    );
  }

  Widget chatControls() {
    addMediaModal() {
      showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: Config.blackColor,
        builder: (context) {
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenWidth(context) * 0.035,
                ),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Icon(
                        Icons.close,
                        color: Config.whiteColor,
                      ),
                      onPressed: () => popCurrentContext(),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Content and tools",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth(context) * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  children: <Widget>[
                    ModalTile(
                      title: "Photo From Gallery",
                      subtitle: "Share Photos",
                      icon: Icons.image,
                      onTap: () {
                        print('GALLERY');
                        pickImage(
                          source: ImageSource.gallery,
                        );
                      },
                    ),
                    ModalTile(
                      title: "Photo From Camera",
                      subtitle: "Share Photos",
                      icon: Icons.camera,
                      onTap: () {
                        print('CAMERA');
                        pickImage(
                          source: ImageSource.camera,
                        );
                      },
                    ),
                    // ModalTile(
                    //   title: "Video From Gallery",
                    //   subtitle: "Share Videos",
                    //   icon: Icons.image,
                    //   onTap: () {
                    //     print('GALLERY');
                    //     pickVideo(
                    //       source: ImageSource.gallery,
                    //     );
                    //   },
                    // ),
                    // ModalTile(
                    //   title: "Video From Camera",
                    //   subtitle: "Share Videos",
                    //   icon: Icons.camera,
                    //   onTap: () {
                    //     print('CAMERA');
                    //     pickVideo(
                    //       source: ImageSource.camera,
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }

    return Container(
      padding: EdgeInsets.all(
        screenWidth(context) * 0.02,
      ),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(),
            child: Container(
              padding: EdgeInsets.all(
                screenWidth(context) * 0.015,
              ),
              decoration: BoxDecoration(
                gradient: Config.fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: Config.whiteColor,
              ),
            ),
          ),
          SizedBox(
            width: screenWidth(context) * 0.015,
          ),
          Expanded(
            child: TextField(
              controller: textFieldController,
              style: TextStyle(
                color: Colors.white,
              ),
              onChanged: (val) {
                (val.length > 0 && val.trim() != "")
                    ? setWriting(true)
                    : setWriting(false);
              },
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(
                  color: Config.greyColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      screenWidth(context) * 0.1,
                    ),
                  ),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth(context) * 0.045,
                  vertical: screenWidth(context) * 0.015,
                ),
                filled: true,
                fillColor: Config.separatorColor,
              ),
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth(context) * 0.025,
                  ),
                  child: Icon(
                    Icons.record_voice_over,
                    color: Config.whiteColor,
                  ),
                ),
          isWriting
              ? Container()
              : Icon(
                  Icons.camera_alt,
                  color: Config.whiteColor,
                ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(
                    left: screenWidth(context) * 0.025,
                  ),
                  decoration: BoxDecoration(
                    gradient: Config.fabGradient,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Config.whiteColor,
                      size: screenWidth(context) * 0.03,
                    ),
                    onPressed: () => sendMessage(),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  navigateToViewMediaView() {
    navigationService.navigateTo(
      ViewMediaViewRoute,
      arguments: receiver,
    );
  }
}
