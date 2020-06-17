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

  customAppBar() {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Config.whiteColor,
        ),
        onPressed: () => popCurrentContext(),
      ),
      centerTitle: true,
      title: Text(
        receiver.fullName,
      ),
    );
  }

  buildBody() {
    TextStyle generalInfoCard = TextStyle(
      fontSize: screenWidth(context) * 0.037,
    );
    TextStyle cardTitle = TextStyle(
      fontSize: screenWidth(context) * 0.045,
      fontWeight: FontWeight.bold,
      color: Config.blackColor,
    );
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            isBusy ? LinearProgressIndicator() : Container(),

            // ======================== First Card (General Information) ========================
            Card(
              color: Colors.white,
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  screenWidth(context) * 0.05,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(
                  screenWidth(context) * 0.05,
                ),
                child: Container(
                  width: screenWidth(context) * 0.8,
                  child: Wrap(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'General Information',
                            style: cardTitle,
                          ),
                          verticalSpaceMedium(context),
                          UserCircle(
                            width: screenWidth(context) * 0.25,
                            height: screenWidth(context) * 0.25,
                            textSize: screenWidth(context) * 0.12,
                            text: utils.getInitials(
                              receiver.fullName,
                            ),
                            image: displayProfileImage(
                              user: receiver,
                            ),
                          ),
                          verticalSpaceMedium(context),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.person,
                                    color: Config.blackColor,
                                    size: screenWidth(context) * 0.05,
                                  ),
                                  SizedBox(
                                    width: screenWidth(context) * 0.02,
                                  ),
                                  Text(
                                    receiver.fullName,
                                    style: generalInfoCard,
                                  ),
                                ],
                              ),
                              verticalSpaceSmall(context),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.email,
                                    color: Config.blackColor,
                                    size: screenWidth(context) * 0.05,
                                  ),
                                  SizedBox(
                                    width: screenWidth(context) * 0.02,
                                  ),
                                  Text(
                                    receiver.email,
                                    style: generalInfoCard,
                                  ),
                                ],
                              ),
                              verticalSpaceSmall(context),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.people,
                                    color: Config.blackColor,
                                    size: screenWidth(context) * 0.05,
                                  ),
                                  SizedBox(
                                    width: screenWidth(context) * 0.02,
                                  ),
                                  TextLink(
                                    'View Friends',
                                    color: Config.blackColor,
                                    onPressed: () {
                                      // TODO: ADD FRIENDS LIST VIEWING
                                      dialogService.showDialog(
                                        title: 'Coming Soon!',
                                        description:
                                            'This feature is under development and is coming soon!',
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ======================== Second Card (Actions) ========================
            Card(
              color: Colors.white,
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  screenWidth(context) * 0.05,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(
                  screenWidth(context) * 0.05,
                ),
                child: Container(
                  width: screenWidth(context) * 0.8,
                  child: Wrap(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Actions',
                            style: cardTitle,
                          ),
                          verticalSpaceMedium(context),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              BusyButton(
                                busy: isBusy,
                                title: 'Start a Chat',
                                onPressed: () async {
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
                                },
                              ),
                              BusyButton(
                                title: friendsIds.contains(receiver.uid)
                                    ? 'Remove Friend'
                                    : 'Add Friend',
                                busy: isBusy,
                                onPressed: () async {
                                  setBusy(true);

                                  await firestoreService.changeFriendsList(
                                    currentUser: currentUser,
                                    friendToAdd: receiver,
                                  );

                                  await getFriendsIds();

                                  setBusy(false);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
