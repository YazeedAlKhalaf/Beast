import 'package:beast/src/app/constants/config.dart';
import 'package:beast/src/app/generated/router/router.gr.dart';
import 'package:beast/src/ui/global/custom_base_view_model.dart';
import 'package:beast/src/ui/global/ui_helpers.dart';
import 'package:beast/src/ui/widgets/busy_button.dart';
import 'package:beast/src/ui/widgets/busy_overlay.dart';
import 'package:beast/src/ui/widgets/custom_app_bar.dart';
import 'package:beast/src/ui/widgets/text_link.dart';
import 'package:beast/src/ui/widgets/user_circle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends CustomBaseViewModel {
  initStateFunc({
    @required BuildContext contextFromFunc,
  }) {
    getVariables(
      contextFromFunc: contextFromFunc,
    );
  }

  BuildContext context;

  getVariables({
    BuildContext contextFromFunc,
  }) {
    context = contextFromFunc;
    notifyListeners();
  }

  signOut() async {
    setBusy(true);
    await authenticationService.signOut();
    navigationService.pushNamedAndRemoveUntil(Routes.loginViewRoute);
  }

  customAppBar() {
    return CustomAppBar(
      centerTitle: true,
      title: Text(
        currentUser.fullName,
      ),
    );
  }

  buildBody() {
    TextStyle generalInfoCard = TextStyle(
      fontSize: screenWidth(context) * 0.037,
      fontWeight: FontWeight.bold,
      color: Config.blackColor,
    );
    TextStyle cardTitle = TextStyle(
      fontSize: screenWidth(context) * 0.045,
      fontWeight: FontWeight.bold,
      color: Config.blackColor,
    );
    return BusyOverlay(
      show: isBusy,
      title: 'Signing Out\nWe hope to see again!',
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // ======================== First Card (General Information) ========================
              Card(
                color: Colors.white,
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    screenWidth(context) * 0.05,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    screenWidth(context) * 0.05,
                  ),
                  child: Container(
                    width: screenWidth(context) * 0.8,
                    child: Wrap(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'General Information',
                                  style: cardTitle,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Config.blackColor,
                                  ),
                                  onPressed: () {
                                    navigateToEditProfileView();
                                  },
                                ),
                              ],
                            ),
                            verticalSpaceMedium(context),
                            UserCircle(
                              width: screenWidth(context) * 0.25,
                              height: screenWidth(context) * 0.25,
                              textSize: screenWidth(context) * 0.12,
                              text: utils.getInitials(
                                currentUser.fullName,
                              ),
                              image: displayProfileImage(
                                user: currentUser,
                              ),
                            ),
                            verticalSpaceMedium(context),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.person,
                                      color: Config.blackColor,
                                      size: screenWidth(context) * 0.05,
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.02,
                                    ),
                                    Text(
                                      currentUser.fullName,
                                      style: generalInfoCard,
                                    ),
                                  ],
                                ),
                                verticalSpaceSmall(context),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.email,
                                      color: Config.blackColor,
                                      size: screenWidth(context) * 0.05,
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.02,
                                    ),
                                    Text(
                                      currentUser.email,
                                      style: generalInfoCard,
                                    ),
                                  ],
                                ),
                                verticalSpaceSmall(context),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.people,
                                      color: Config.blackColor,
                                      size: screenWidth(context) * 0.05,
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.02,
                                    ),
                                    TextLink(
                                      'View Friends',
                                      color: Config.blackColor,
                                      onPressed: () {
                                        // TODO: ADD FRIENDS LIST VIEWING
                                        dialogService.showDialog(
                                          title: 'Coming Soon!',
                                          description:
                                              'This feature is under development and is coming soon!',
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ======================== Second Card (Actions) ========================
              Card(
                color: Colors.white,
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    screenWidth(context) * 0.05,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    screenWidth(context) * 0.05,
                  ),
                  child: Container(
                    width: screenWidth(context) * 0.8,
                    child: Wrap(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Actions',
                              style: cardTitle,
                            ),
                            verticalSpaceMedium(context),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                BusyButton(
                                  title: 'Sign Out',
                                  onPressed: () {
                                    signOut();
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  navigateToEditProfileView() {
    navigationService.navigateTo(Routes.editProfileViewRoute);
  }
}
