import 'package:beast/src/models/user.dart';
import 'package:beast/src/ui/views/chats_view.dart';
import 'package:beast/src/ui/views/search_view.dart';
import 'package:beast/src/viewmodels/base_model.dart';
import 'package:flutter/cupertino.dart';

class HomeViewModel extends BaseModel {
  initStateFunc() {
    getFriendsList();
  }

  int currentIndex = 0;

  List<User> friends = [];

  // Only Two Screens
  List<Widget> screens = [
    Container(child: ChatsView()),
    Container(child: SearchView()),
  ];

  onTapBottomNavBar(int index) {
    currentIndex = index;
    notifyListeners();
  }

  getFriendsList() async {
    List<User> friendsList =
        await firestoreService.getFriends(currentUser.friends);
    friends = friendsList;
    notifyListeners();
  }
}
