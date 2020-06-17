import 'package:beast/src/app/generated/router/router.gr.dart';
import 'package:beast/src/ui/global/custom_base_view_model.dart';
import 'package:flutter/material.dart';

class SignUpViewModel extends CustomBaseViewModel {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future signUp() async {
    setBusy(true);

    var result = await authenticationService.signUpWithEmail(
      email: emailController.text,
      password: passwordController.text,
      fullName: fullNameController.text,
      username: usernameController.text,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        navigationService.pushNamedAndRemoveUntil(Routes.homeViewRoute);
      } else {
        await dialogService.showDialog(
          title: 'Something went wrong!',
          description: 'It\'s our fault, Please try again later.',
        );
      }
    } else {
      switch (result) {
        case 'Given String is empty or null':
          await dialogService.showDialog(
            title: 'Something went wrong!',
            description:
                'Some or all fields are empty! \nAll fields are required',
          );
          break;
        case 'The email address is badly formatted.':
          await dialogService.showDialog(
            title: 'Something went wrong!',
            description:
                'The email you entered is wrong or can\'t be used! \nPlease try again.',
          );
          break;
        case 'The given password is invalid. [ Password should be at least 6 characters ]':
          await dialogService.showDialog(
            title: 'Something went wrong!',
            description:
                'The password you entered is invalid! \nPassword must be at least 6 characters.',
          );
          break;
        case 'The email address is already in use by another account.':
          await dialogService.showDialog(
            title: 'Something went wrong!',
            description:
                'The email you entered is already in use! \nPlease try using another one.',
          );
          break;
        default:
          print(result);
          await dialogService.showDialog(
            title: 'Something went wrong!',
            description:
                'It\'s our fault, Please try again later. \nIf the problem persists, contact us at: yazeedfady@gmail.com',
          );
      }
    }
  }

  void navigateToLogin() {
    navigationService.pushNamedAndRemoveUntil(Routes.loginViewRoute);
  }
}
