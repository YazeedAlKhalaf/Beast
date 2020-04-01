import 'package:beast/src/constants/route_names.dart';
import 'package:beast/src/ui/views/chat_view.dart';
import 'package:beast/src/ui/views/chats_view.dart';
import 'package:beast/src/ui/views/edit_profile_view.dart';
import 'package:beast/src/ui/views/home_view.dart';
import 'package:beast/src/ui/views/profile_view.dart';
import 'package:beast/src/ui/views/search_view.dart';
import 'package:beast/src/ui/views/user_details_view.dart';
import 'package:beast/src/viewmodels/edit_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:beast/src/ui/views/login_view.dart';
import 'package:beast/src/ui/views/signup_view.dart';
import 'package:beast/src/ui/views/view_media_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpView(),
      );
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomeView(),
      );
    case ChatsViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ChatsView(),
      );
    case SearchViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SearchView(),
      );
    case ChatViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ChatView(
          receiver: settings.arguments,
        ),
      );
    case UserDetailsViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: UserDetailsView(
          receiver: settings.arguments,
        ),
      );
    case ProfileViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ProfileView(),
      );
    case EditProfileViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: EditProfileView(),
      );
      break;
    case ViewMediaViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ViewMediaView(
          receiver: settings.arguments,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text(
              'No route defined for ${settings.name}',
            ),
          ),
        ),
      );
  }
}

PageRoute _getPageRoute({
  String routeName,
  Widget viewToShow,
}) {
  return MaterialPageRoute(
    settings: RouteSettings(
      name: routeName,
    ),
    builder: (_) => viewToShow,
  );
}
