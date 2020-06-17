import 'package:beast/src/app/models/user.dart';
import 'package:beast/src/ui/global/custom_base_view_model.dart';
import 'package:beast/src/ui/views/chats/chats_view.dart';
import 'package:beast/src/ui/views/search/search_view.dart';
import 'package:flutter/cupertino.dart';

class HomeViewModel extends CustomBaseViewModel {
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
