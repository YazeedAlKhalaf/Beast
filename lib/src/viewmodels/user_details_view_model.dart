import 'package:beast/src/constants/config.dart';
import 'package:beast/src/constants/route_names.dart';
import 'package:beast/src/models/user.dart';
import 'package:beast/src/ui/shared/ui_helpers.dart';
import 'package:beast/src/ui/widgets/custom_app_bar.dart';
import 'package:beast/src/ui/widgets/text_link.dart';
import 'package:beast/src/ui/widgets/user_circle.dart';
import 'package:beast/src/viewmodels/base_model.dart';
import 'package:flutter/material.dart';

class UserDetailsViewModel extends BaseModel {
  initStateFunc({
    @required BuildContext contextFromFunc,
    @required User receiverFromFunc,
  }) {
    getVariables(
      contextFromFunc: contextFromFunc,
      receiverFromFunc: receiverFromFunc,
    );
  }

  BuildContext context;
  User receiver;

  getVariables({
    @required BuildContext contextFromFunc,
    @required User receiverFromFunc,
  }) {
    context = contextFromFunc;
    receiver = receiverFromFunc;
    notifyListeners();
  }

  customAppBar() {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Config.whiteColor,
        ),
        onPressed: () => popCurrentContext(),
      ),
      centerTitle: true,
      title: Text(
        receiver.fullName,
      ),
    );
  }

  buildBody() {
    TextStyle generalInfoCard = TextStyle(
      fontSize: screenWidth(context) * 0.037,
    );
    TextStyle cardTitle = TextStyle(
      fontSize: screenWidth(context) * 0.045,
      fontWeight: FontWeight.bold,
      color: Config.blackColor,
    );
    return Center(
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
                          Text(
                            'General Information',
                            style: cardTitle,
                          ),
                          verticalSpaceMedium,
                          UserCircle(
                            width: screenWidth(context) * 0.25,
                            height: screenWidth(context) * 0.25,
                            textSize: screenWidth(context) * 0.12,
                            text: utils.getInitials(
                              receiver.fullName,
                            ),
                          ),
                          verticalSpaceMedium,
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
                                    receiver.fullName,
                                    style: generalInfoCard,
                                  ),
                                ],
                              ),
                              verticalSpaceSmall,
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
                                    receiver.email,
                                    style: generalInfoCard,
                                  ),
                                ],
                              ),
                              verticalSpaceSmall,
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
          ],
        ),
      ),
    );
  }
}
