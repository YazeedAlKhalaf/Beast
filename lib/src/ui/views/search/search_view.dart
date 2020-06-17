import 'package:beast/src/app/constants/config.dart';
import 'package:beast/src/app/models/user.dart';
import 'package:beast/src/ui/global/app_colors.dart';
import 'package:beast/src/ui/global/ui_helpers.dart';
import 'package:beast/src/ui/views/search/search_view_model.dart';
import 'package:beast/src/ui/widgets/busy_button.dart';
import 'package:beast/src/ui/widgets/custom_tile.dart';
import 'package:beast/src/ui/widgets/user_circle.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:stacked/stacked.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      viewModelBuilder: () => SearchViewModel(),
      onModelReady: (SearchViewModel model) => model.initStateFunc(),
      builder: (
        BuildContext context,
        SearchViewModel model,
        Widget child,
      ) {
        searchAppBar() {
          return GradientAppBar(
            gradient: Config.fabGradient,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(
                kToolbarHeight + blockSizeHorizontal(context) * 4,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      left: blockSizeHorizontal(context) * 4,
                    ),
                    child: TextField(
                      controller: model.searchController,
                      onChanged: model.onChangedSearch,
                      cursorColor: primaryColor,
                      autofocus: false,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: blockSizeHorizontal(context) * 7,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) => model.searchController.clear(),
                            );
                          },
                        ),
                        border: InputBorder.none,
                        hintText: "Search",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: blockSizeHorizontal(context) * 7,
                          color: Color(0x88ffffff),
                        ),
                      ),
                    ),
                  ),
                  model.isBusy
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
          final List<User> suggestionList = model.query.isEmpty
              ? []
              : model.userList.where((User user) {
                  String _getUsername = user.username.toLowerCase();
                  String _query = model.query.toLowerCase();
                  String _getName = user.fullName.toLowerCase();
                  bool matchesUsername = _getUsername.contains(_query);
                  bool matchesName = _getName.contains(_query);

                  return (matchesUsername || matchesName);
                }).toList();

          return Container(
            padding: EdgeInsets.all(blockSizeHorizontal(context) * 3),
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
                    model.navigateToUserDetailsView(
                      receiver: searchedUser,
                    );
                  },
                  leading: UserCircle(
                    width: blockSizeHorizontal(context) * 10,
                    height: blockSizeHorizontal(context) * 10,
                    text: model.utils.getInitials(searchedUser.fullName),
                    textSize: blockSizeHorizontal(context) * 5,
                    image: model.displayProfileImage(
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
                    title: model.friendsIds.contains(
                      searchedUser.uid,
                    )
                        ? 'Remove'
                        : 'Add',
                    busy: model.isBusy,
                    onPressed: () async {
                      await model.addRemoveButtonOnPressed(
                        searchedUser: searchedUser,
                      );
                    },
                  ),
                );
              }),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Config.blackColor,
          appBar: searchAppBar(),
          body: buildSuggestions(),
        );
      },
    );
  }
}
