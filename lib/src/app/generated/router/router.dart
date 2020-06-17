import 'package:auto_route/auto_route_annotations.dart';
import 'package:beast/src/ui/views/chat/chat_view.dart';
import 'package:beast/src/ui/views/chats/chats_view.dart';
import 'package:beast/src/ui/views/edit_profile/edit_profile_view.dart';
import 'package:beast/src/ui/views/login/login_view.dart';
import 'package:beast/src/ui/views/profile/profile_view.dart';
import 'package:beast/src/ui/views/search/search_view.dart';
import 'package:beast/src/ui/views/sign_up/signup_view.dart';
import 'package:beast/src/ui/views/startup/startup_view.dart';
import 'package:beast/src/ui/views/home/home_view.dart';
import 'package:beast/src/ui/views/user_details/user_details_view.dart';
import 'package:beast/src/ui/views/view_media/view_media_view.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  StartupView startupViewRoute;

  HomeView homeViewRoute;

  LoginView loginViewRoute;

  SignUpView signUpViewRoute;

  ChatView chatViewRoute;

  ChatsView chatsViewRoute;

  EditProfileView editProfileViewRoute;

  ProfileView profileViewRoute;

  SearchView searchViewRoute;

  UserDetailsView userDetailsViewRoute;

  ViewMediaView viewMediaViewRoute;
}
