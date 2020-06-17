import 'package:beast/src/app/constants/config.dart';
import 'package:beast/src/app/generated/router/router.gr.dart';
import 'package:beast/src/app/models/user.dart';
import 'package:beast/src/ui/global/custom_base_view_model.dart';
import 'package:beast/src/ui/global/ui_helpers.dart';
import 'package:beast/src/ui/widgets/busy_button.dart';
import 'package:beast/src/ui/widgets/custom_app_bar.dart';
import 'package:beast/src/ui/widgets/text_link.dart';
import 'package:beast/src/ui/widgets/user_circle.dart';
import 'package:flutter/material.dart';

class UserDetailsViewModel extends CustomBaseViewModel {
  initStateFunc({
    @required BuildContext contextFromFunc,
    @required User receiverFromFunc,
  }) {
    getFriendsIds();
    getVariables(
      contextFromFunc: contextFromFunc,
      receiverFromFunc: receiverFromFunc,
    );
  }

  BuildContext context;
  User receiver;

  List<String> friendsIds = [];

  getFriendsIds() async {
    friendsIds = await firestoreService.getFriendsIds(currentUser);
    notifyListeners();
  }

  getVariables({
    @required BuildContext contextFromFunc,
    @required User receiverFromFunc,
  }) {
    context = contextFromFunc;
    receiver = receiverFromFunc;
    notifyListeners();
  }

  startAChatButtonOnPressed() async {
    setBusy(true);
    await firestoreService
        .createChat(
      sender: currentUser,
      receiver: receiver,
    )
        .then((value) {
      if (value is String) {
        dialogService.showDialog(
          title: 'Something went wrong!',
          description: value,
        );
        setBusy(false);
      } else {
        setBusy(false);
        navigationService.navigateTo(
          Routes.chatViewRoute,
          arguments: ChatViewArguments(
            receiver: receiver,
          ),
        );
      }
    });
  }

  addRemoveButtonOnPressed() async {
    setBusy(true);

    await firestoreService.changeFriendsList(
      currentUser: currentUser,
      friendToAdd: receiver,
    );

    await getFriendsIds();

    setBusy(false);
  }

  viewFriendsOnPressed() async {
    await navigationService.navigateTo(
      Routes.friendsListViewRoute,
      arguments: FriendsListViewArguments(
        user: receiver,
      ),
    );
  }
}
