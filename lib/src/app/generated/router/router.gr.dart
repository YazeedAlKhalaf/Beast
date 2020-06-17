// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:beast/src/ui/views/startup/startup_view.dart';
import 'package:beast/src/ui/views/home/home_view.dart';
import 'package:beast/src/ui/views/login/login_view.dart';
import 'package:beast/src/ui/views/sign_up/signup_view.dart';
import 'package:beast/src/ui/views/chat/chat_view.dart';
import 'package:beast/src/app/models/user.dart';
import 'package:beast/src/ui/views/chats/chats_view.dart';
import 'package:beast/src/ui/views/edit_profile/edit_profile_view.dart';
import 'package:beast/src/ui/views/profile/profile_view.dart';
import 'package:beast/src/ui/views/search/search_view.dart';
import 'package:beast/src/ui/views/user_details/user_details_view.dart';
import 'package:beast/src/ui/views/view_media/view_media_view.dart';

abstract class Routes {
  static const startupViewRoute = '/';
  static const homeViewRoute = '/home-view-route';
  static const loginViewRoute = '/login-view-route';
  static const signUpViewRoute = '/sign-up-view-route';
  static const chatViewRoute = '/chat-view-route';
  static const chatsViewRoute = '/chats-view-route';
  static const editProfileViewRoute = '/edit-profile-view-route';
  static const profileViewRoute = '/profile-view-route';
  static const searchViewRoute = '/search-view-route';
  static const userDetailsViewRoute = '/user-details-view-route';
  static const viewMediaViewRoute = '/view-media-view-route';
  static const all = {
    startupViewRoute,
    homeViewRoute,
    loginViewRoute,
    signUpViewRoute,
    chatViewRoute,
    chatsViewRoute,
    editProfileViewRoute,
    profileViewRoute,
    searchViewRoute,
    userDetailsViewRoute,
    viewMediaViewRoute,
  };
}

class Router extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;

  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.startupViewRoute:
        return MaterialPageRoute<dynamic>(
          builder: (context) => StartupView(),
          settings: settings,
        );
      case Routes.homeViewRoute:
        return MaterialPageRoute<dynamic>(
          builder: (context) => HomeView(),
          settings: settings,
        );
      case Routes.loginViewRoute:
        return MaterialPageRoute<dynamic>(
          builder: (context) => LoginView(),
          settings: settings,
        );
      case Routes.signUpViewRoute:
        return MaterialPageRoute<dynamic>(
          builder: (context) => SignUpView(),
          settings: settings,
        );
      case Routes.chatViewRoute:
        if (hasInvalidArgs<ChatViewArguments>(args)) {
          return misTypedArgsRoute<ChatViewArguments>(args);
        }
        final typedArgs = args as ChatViewArguments ?? ChatViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => ChatView(receiver: typedArgs.receiver),
          settings: settings,
        );
      case Routes.chatsViewRoute:
        return MaterialPageRoute<dynamic>(
          builder: (context) => ChatsView(),
          settings: settings,
        );
      case Routes.editProfileViewRoute:
        return MaterialPageRoute<dynamic>(
          builder: (context) => EditProfileView(),
          settings: settings,
        );
      case Routes.profileViewRoute:
        return MaterialPageRoute<dynamic>(
          builder: (context) => ProfileView(),
          settings: settings,
        );
      case Routes.searchViewRoute:
        return MaterialPageRoute<dynamic>(
          builder: (context) => SearchView(),
          settings: settings,
        );
      case Routes.userDetailsViewRoute:
        if (hasInvalidArgs<UserDetailsViewArguments>(args)) {
          return misTypedArgsRoute<UserDetailsViewArguments>(args);
        }
        final typedArgs =
            args as UserDetailsViewArguments ?? UserDetailsViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => UserDetailsView(receiver: typedArgs.receiver),
          settings: settings,
        );
      case Routes.viewMediaViewRoute:
        if (hasInvalidArgs<ViewMediaViewArguments>(args)) {
          return misTypedArgsRoute<ViewMediaViewArguments>(args);
        }
        final typedArgs =
            args as ViewMediaViewArguments ?? ViewMediaViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => ViewMediaView(receiver: typedArgs.receiver),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//ChatView arguments holder class
class ChatViewArguments {
  final User receiver;
  ChatViewArguments({this.receiver});
}

//UserDetailsView arguments holder class
class UserDetailsViewArguments {
  final User receiver;
  UserDetailsViewArguments({this.receiver});
}

//ViewMediaView arguments holder class
class ViewMediaViewArguments {
  final User receiver;
  ViewMediaViewArguments({this.receiver});
}
