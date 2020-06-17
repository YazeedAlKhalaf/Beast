import 'package:beast/src/app/constants/config.dart';
import 'package:beast/src/app/generated/router/router.gr.dart';
import 'package:beast/src/app/models/user.dart';
import 'package:beast/src/ui/global/app_colors.dart';
import 'package:beast/src/ui/global/ui_helpers.dart';
import 'package:beast/src/ui/views/user_details/user_details_view_model.dart';
import 'package:beast/src/ui/widgets/busy_button.dart';
import 'package:beast/src/ui/widgets/custom_app_bar.dart';
import 'package:beast/src/ui/widgets/text_link.dart';
import 'package:beast/src/ui/widgets/user_circle.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class UserDetailsView extends StatefulWidget {
  final User receiver;

  UserDetailsView({
    this.receiver,
  });
  @override
  _UserDetailsViewState createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserDetailsViewModel>.reactive(
      viewModelBuilder: () => UserDetailsViewModel(),
      onModelReady: (UserDetailsViewModel model) => model.initStateFunc(
        contextFromFunc: context,
        receiverFromFunc: widget.receiver,
      ),
      builder: (
        BuildContext context,
        UserDetailsViewModel model,
        Widget child,
      ) {
        buildBody() {
          TextStyle generalInfoCard = TextStyle(
            fontSize: blockSizeHorizontal(context) * 3.7,
          );
          TextStyle cardTitle = TextStyle(
            fontSize: blockSizeHorizontal(context) * 4.5,
            fontWeight: FontWeight.bold,
            color: Config.blackColor,
          );
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  model.isBusy ? LinearProgressIndicator() : Container(),

                  // ======================== First Card (General Information) ========================
                  Card(
                    color: Colors.white,
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        blockSizeHorizontal(context) * 5,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                        blockSizeHorizontal(context) * 5,
                      ),
                      child: Container(
                        width: blockSizeHorizontal(context) * 80,
                        child: Wrap(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'General Information',
                                  style: cardTitle,
                                ),
                                verticalSpaceMedium(context),
                                UserCircle(
                                  width: blockSizeHorizontal(context) * 25,
                                  height: blockSizeHorizontal(context) * 25,
                                  textSize: blockSizeHorizontal(context) * 12,
                                  text: model.utils.getInitials(
                                    model.receiver.fullName,
                                  ),
                                  image: model.displayProfileImage(
                                    user: model.receiver,
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
                                          color: primaryColor,
                                          size:
                                              blockSizeHorizontal(context) * 5,
                                        ),
                                        SizedBox(
                                          width:
                                              blockSizeHorizontal(context) * 2,
                                        ),
                                        Text(
                                          model.receiver.fullName,
                                          style: generalInfoCard,
                                        ),
                                      ],
                                    ),
                                    verticalSpaceSmall(context),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.email,
                                          color: primaryColor,
                                          size:
                                              blockSizeHorizontal(context) * 5,
                                        ),
                                        SizedBox(
                                          width:
                                              blockSizeHorizontal(context) * 2,
                                        ),
                                        Text(
                                          model.receiver.email,
                                          style: generalInfoCard,
                                        ),
                                      ],
                                    ),
                                    verticalSpaceSmall(context),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.people,
                                          color: primaryColor,
                                          size:
                                              blockSizeHorizontal(context) * 5,
                                        ),
                                        SizedBox(
                                          width:
                                              blockSizeHorizontal(context) * 2,
                                        ),
                                        TextLink(
                                          'View Friends',
                                          color: Config.blackColor,
                                          onPressed: () async {
                                            await model.viewFriendsOnPressed();
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
                        blockSizeHorizontal(context) * 5,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                        blockSizeHorizontal(context) * 5,
                      ),
                      child: Container(
                        width: blockSizeHorizontal(context) * 80,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    BusyButton(
                                      busy: model.isBusy,
                                      title: 'Start a Chat',
                                      onPressed: () async {
                                        await model.startAChatButtonOnPressed();
                                      },
                                    ),
                                    BusyButton(
                                      title: model.friendsIds
                                              .contains(model.receiver.uid)
                                          ? 'Remove Friend'
                                          : 'Add Friend',
                                      busy: model.isBusy,
                                      onPressed: () async {
                                        await model.addRemoveButtonOnPressed();
                                      },
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

        return Scaffold(
          backgroundColor: Config.blackColor,
          appBar: CustomAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Config.whiteColor,
              ),
              onPressed: () => model.popCurrentContext(),
            ),
            centerTitle: true,
            title: Text(
              model.receiver.fullName,
            ),
          ),
          body: buildBody(),
        );
      },
    );
  }
}
