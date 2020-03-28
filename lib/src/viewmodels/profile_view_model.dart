import 'package:beast/src/constants/route_names.dart';
import 'package:beast/src/ui/widgets/busy_button.dart';
import 'package:beast/src/ui/widgets/custom_app_bar.dart';
import 'package:beast/src/viewmodels/base_model.dart';
import 'package:flutter/cupertino.dart';

class ProfileViewModel extends BaseModel {
  signOut() async {
    await authenticationService.signOut();
    navigationService.navigateToAndRemoveUntill(LoginViewRoute);
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
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            BusyButton(
              busy: busy,
              title: 'Sign Out',
              onPressed: () {
                signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
