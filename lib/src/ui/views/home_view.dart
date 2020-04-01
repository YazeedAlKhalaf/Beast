import 'package:beast/src/constants/config.dart';
import 'package:beast/src/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
      viewModel: HomeViewModel(),
      builder: (
        BuildContext context,
        HomeViewModel model,
        Widget child,
      ) {
        return Scaffold(
          backgroundColor: Config.blackColor,
          body: model.screens[model.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Config.blackColor,
            onTap: (index) {
              model.onTapBottomNavBar(index);
            },
            currentIndex: model.currentIndex,
            items: [
              // Chats Tab
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                  color: model.currentIndex == 0
                      ? Config.whiteColor
                      : Config.greyColor,
                ),
                title: Text(
                  'Chats',
                  style: TextStyle(
                    color: model.currentIndex == 0
                        ? Config.whiteColor
                        : Config.greyColor,
                  ),
                ),
              ),
              // Search Tab
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: model.currentIndex == 1
                      ? Config.whiteColor
                      : Config.greyColor,
                ),
                title: Text(
                  'Search',
                  style: TextStyle(
                    color: model.currentIndex == 1
                        ? Config.whiteColor
                        : Config.greyColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
