import 'package:beast/src/constants/config.dart';
import 'package:beast/src/constants/route_names.dart';
import 'package:beast/src/locator.dart';
import 'package:beast/src/models/user.dart';
import 'package:beast/src/services/firestore_service.dart';
import 'package:beast/src/ui/shared/ui_helpers.dart';
import 'package:beast/src/ui/widgets/busy_button.dart';
import 'package:beast/src/ui/widgets/custom_tile.dart';
import 'package:beast/src/ui/widgets/user_circle.dart';
import 'package:beast/src/viewmodels/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class SearchViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  BuildContext context;
  bool needPopping;

  initStateFunc({
    @required BuildContext contextFunc,
  }) async {
    getAllUsers();
    getVariables(
      contextFunc: contextFunc,
    );
    getFriendsIds();
  }

  List<User> userList;
  String query = '';
  TextEditingController searchController = TextEditingController();

  List<String> friendsIds = [];

  getFriendsIds() async {
    friendsIds = await firestoreService.getFriendsIds(currentUser);
    notifyListeners();
  }

  getAllUsers() async {
    userList = await _firestoreService.getAllUsers(currentUser);
    notifyListeners();
  }

  getVariables({
    BuildContext contextFunc,
  }) {
    context = contextFunc;
    notifyListeners();
  }

  searchAppBar() {
    return GradientAppBar(
      gradient: Config.fabGradient,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(
          kToolbarHeight + screenWidth(context) * 0.04,
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth(context) * 0.04,
              ),
              child: TextField(
                controller: searchController,
                onChanged: (val) {
                  query = val;
                  getAllUsers();
                  notifyListeners();
                },
                cursorColor: Config.blackColor,
                autofocus: false,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: screenWidth(context) * 0.07,
                ),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => searchController.clear(),
                      );
                    },
                  ),
                  border: InputBorder.none,
                  hintText: "Search",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth(context) * 0.07,
                    color: Color(0x88ffffff),
                  ),
                ),
              ),
            ),
            busy
                ? LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                      Config.blackColor,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  buildSuggestions() {
    final List<User> suggestionList = query.isEmpty
        ? []
        : userList.where((User user) {
            String _getUsername = user.username.toLowerCase();
            String _query = query.toLowerCase();
            String _getName = user.fullName.toLowerCase();
            bool matchesUsername = _getUsername.contains(_query);
            bool matchesName = _getName.contains(_query);

            return (matchesUsername || matchesName);
          }).toList();

    return Container(
      padding: EdgeInsets.all(screenWidth(context) * 0.03),
      child: ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: ((BuildContext context, int index) {
          User searchedUser = User(
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,
            fullName: suggestionList[index].fullName,
            username: suggestionList[index].username,
            email: suggestionList[index].email,
            friends: suggestionList[index].friends,
          );

          return CustomTile(
            mini: false,
            onTap: () {
              navigateToUserDetailsView(
                receiver: searchedUser,
              );
            },
            leading: UserCircle(
              width: screenWidth(context) * 0.1,
              height: screenWidth(context) * 0.1,
              text: utils.getInitials(searchedUser.fullName),
              textSize: screenWidth(context) * 0.05,
              image: displayProfileImage(
                user: searchedUser,
              ),
            ),
            title: Text(
              searchedUser.username,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              searchedUser.fullName,
              style: TextStyle(
                color: Config.greyColor,
              ),
            ),
            trailing: BusyButton(
              title: friendsIds.contains(searchedUser.uid) ? 'Remove' : 'Add',
              busy: busy,
              onPressed: () async {
                setBusy(true);

                notifyListeners();

                await firestoreService.changeFriendsList(
                  currentUser: currentUser,
                  friendToAdd: searchedUser,
                );

                await getFriendsIds();

                setBusy(false);
              },
            ),
          );
        }),
      ),
    );
  }

  navigateToUserDetailsView({
    User receiver,
  }) {
    navigationService.navigateTo(
      UserDetailsViewRoute,
      arguments: receiver,
    );
  }
}
