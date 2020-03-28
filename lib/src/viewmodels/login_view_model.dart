import 'package:beast/src/constants/route_names.dart';
import 'package:flutter/foundation.dart';

import 'base_model.dart';

class LoginViewModel extends BaseModel {
  Future login({
    @required String email,
    @required String password,
  }) async {
    setBusy(true);

    var result = await authenticationService.loginWithEmail(
      email: email,
      password: password,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        navigationService.navigateToAndRemoveUntill(HomeViewRoute);
      } else {
        await dialogService.showDialog(
          title: 'Login Failure',
          description:
              'Something went wrong! It not your fault, Please try again later.',
        );
      }
    } else {
      await dialogService.showDialog(
        title: 'Login Failure',
        description: result,
      );
    }
  }

  void navigateToSignUp() {
    navigationService.navigateToAndRemoveUntill(SignUpViewRoute);
  }
}
