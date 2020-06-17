import 'package:beast/src/app/models/user.dart';
import 'package:beast/src/ui/global/app_colors.dart';
import 'package:beast/src/ui/global/ui_helpers.dart';
import 'package:beast/src/ui/widgets/busy_button.dart';
import 'package:beast/src/ui/widgets/busy_overlay.dart';
import 'package:beast/src/ui/widgets/custom_app_bar.dart';
import 'package:beast/src/ui/widgets/custom_tile.dart';
import 'package:beast/src/ui/widgets/user_circle.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import './friends_list_view_model.dart';

class FriendsListView extends StatelessWidget {
  final User user;

  const FriendsListView({this.user});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FriendsListViewModel>.nonReactive(
      viewModelBuilder: () => FriendsListViewModel(),
      onModelReady: (FriendsListViewModel model) async =>
          await model.initStateFunc(
        user: user,
      ),
      builder: (
        BuildContext context,
        FriendsListViewModel model,
        Widget child,
      ) {
        return BusyOverlay(
          show: model.isBusy,
          child: Scaffold(
            appBar: CustomAppBar(
              title: Text('${user.fullName} Friends'),
              centerTitle: true,
            ),
            body: Center(
              child: Container(
                child: ListView.builder(
                  itemCount: model.friendsList.length,
                  itemBuilder: ((BuildContext context, int index) {
                    final List<User> friendsList =
                        model.friendsList.isEmpty ? [] : model.friendsList;

                    if (model.friendsList.isEmpty) {
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

                    User friend = User(
                      uid: friendsList[index].uid,
                      profilePhoto: friendsList[index].profilePhoto,
                      fullName: friendsList[index].fullName,
                      username: friendsList[index].username,
                      email: friendsList[index].email,
                      friends: friendsList[index].friends,
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
                          model.navigateToUserDetailsView(
                            receiver: friend,
                          );
                        },
                        title: Text(
                          friend.username,
                          style: TextStyle(
                            color: textColorWhite,
                            fontSize: blockSizeHorizontal(context) * 5,
                          ),
                        ),
                        subtitle: Text(
                          friend.fullName,
                          style: TextStyle(
                            color: lynchColor,
                            fontSize: blockSizeHorizontal(context) * 3,
                          ),
                        ),
                        leading: UserCircle(
                          width: blockSizeHorizontal(context) * 10,
                          height: blockSizeHorizontal(context) * 10,
                          textSize: blockSizeHorizontal(context) * 3.5,
                          text: model.utils.getInitials(friend.fullName),
                          image: model.displayProfileImage(
                            user: friend,
                          ),
                        ),
                        trailing: BusyButton(
                          title: model.friendsIds.contains(
                            friend.uid,
                          )
                              ? 'Remove'
                              : 'Add',
                          busy: model.isBusy,
                          onPressed: () async {
                            await model.addRemoveButtonOnPressed(
                              searchedUser: friend,
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
