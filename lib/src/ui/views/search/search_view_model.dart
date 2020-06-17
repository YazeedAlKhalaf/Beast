import 'package:beast/src/app/generated/locator/locator.dart';
import 'package:beast/src/app/generated/router/router.gr.dart';
import 'package:beast/src/app/models/user.dart';
import 'package:beast/src/app/services/firestore_service.dart';
import 'package:beast/src/ui/global/custom_base_view_model.dart';
import 'package:flutter/material.dart';

class SearchViewModel extends CustomBaseViewModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  bool needPopping;

  initStateFunc() async {
    getAllUsers();
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

  onChangedSearch(String value) {
    query = value;
    getAllUsers();
    notifyListeners();
  }

  addRemoveButtonOnPressed({@required User searchedUser}) async {
    setBusy(true);

    notifyListeners();

    await firestoreService.changeFriendsList(
      currentUser: currentUser,
      friendToAdd: searchedUser,
    );

    await getFriendsIds();

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
