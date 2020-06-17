import 'package:beast/src/app/generated/router/router.gr.dart';
import 'package:beast/src/ui/global/custom_base_view_model.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends CustomBaseViewModel {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    setBusy(true);

    var result = await authenticationService.loginWithEmail(
      email: emailController.text,
      password: passwordController.text,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        navigationService.pushNamedAndRemoveUntil(Routes.homeViewRoute);
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
    navigationService.pushNamedAndRemoveUntil(Routes.signUpViewRoute);
  }
}
