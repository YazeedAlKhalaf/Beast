import 'package:beast/src/constants/config.dart';
import 'package:beast/src/constants/route_names.dart';
import 'package:beast/src/models/user.dart';
import 'package:beast/src/ui/shared/ui_helpers.dart';
import 'package:beast/src/ui/widgets/custom_app_bar.dart';
import 'package:beast/src/ui/widgets/custom_tile.dart';
import 'package:beast/src/ui/widgets/user_circle.dart';
import 'package:beast/src/viewmodels/base_model.dart';
import 'package:flutter/material.dart';

class ChatsViewModel extends BaseModel {
  initStateFunc({
    BuildContext contextFromFunc,
  }) {
    getFriendsList();
    getContext(
      contextFromFunc: contextFromFunc,
    );
  }

  BuildContext context;

  List<User> friends = [];

  getFriendsList() async {
    List<User> friendsList =
        await firestoreService.getFriends(currentUser.friends);
    friends = friendsList;
    notifyListeners();
  }

  getContext({
    BuildContext contextFromFunc,
  }) {
    context = contextFromFunc;
    notifyListeners();
  }

  buildChatsList() {
    return Container(
      padding: EdgeInsets.all(screenWidth(context) * 0.025),
      child: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (BuildContext context, int index) {
          User friend = User(
            uid: friends[index].uid,
            fullName: friends[index].fullName,
            username: friends[index].username,
            email: friends[index].email,
            profilePhoto: friends[index].profilePhoto,
            friends: friends[index].friends,
          );
          return CustomTile(
            mini: false,
            onTap: () {
              navigateToChatView(
                receiver: friend,
              );
            },
            title: Text(
              friend.fullName,
              style: TextStyle(
                color: Config.whiteColor,
                fontSize: screenWidth(context) * 0.05,
              ),
            ),
            subtitle: Text(
              // TODO: Implement messages then make this dynamic
              'You: hahaha',
              style: TextStyle(
                color: Config.greyColor,
                fontSize: screenWidth(context) * 0.03,
              ),
            ),
            leading: UserCircle(
              width: screenWidth(context) * 0.1,
              height: screenWidth(context) * 0.1,
              textSize: screenWidth(context) * 0.035,
              image: friend.profilePhoto != null
                  ? Image.network(friend.profilePhoto)
                  : Image.asset('assets/images/icon_large.png'),
              text: utils.getInitials(friend.fullName),
            ),
          );
        },
      ),
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
