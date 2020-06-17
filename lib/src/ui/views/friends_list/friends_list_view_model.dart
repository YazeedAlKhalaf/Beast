import 'package:beast/src/app/generated/router/router.gr.dart';
import 'package:beast/src/app/models/user.dart';
import 'package:beast/src/ui/global/custom_base_view_model.dart';
import 'package:flutter/foundation.dart';

class FriendsListViewModel extends CustomBaseViewModel {
  User _user;
  User get user => _user;

  List<String> _friendsIds = <String>[];
  List<String> get friendsIds => _friendsIds;

  List<User> _friendsList = <User>[];
  List<User> get friendsList => _friendsList;

  initStateFunc({@required User user}) async {
    setBusy(true);
    _user = user;
    notifyListeners();
    await _getFriendsList();
    setBusy(false);
  }

  _getFriendsList() async {
    setBusy(true);
    _friendsIds = await firestoreService.getFriendsIds(user);
    _friendsList = await firestoreService.getFriends(_friendsIds);
    notifyListeners();
    setBusy(false);
  }

  addRemoveButtonOnPressed({@required User searchedUser}) async {
    setBusy(true);

    notifyListeners();

    await firestoreService.changeFriendsList(
      currentUser: currentUser,
      friendToAdd: searchedUser,
    );

    await _getFriendsList();

    setBusy(false);
  }

  navigateToUserDetailsView({
    User receiver,
  }) {
    navigationService.navigateTo(
      Routes.userDetailsViewRoute,
      arguments: UserDetailsViewArguments(
        receiver: receiver,
      ),
    );
  }
}
