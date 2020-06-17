import 'package:beast/main.dart';
import 'package:beast/src/app/constants/config.dart';
import 'package:beast/src/ui/global/ui_helpers.dart';
import 'package:beast/src/ui/views/sign_up/signup_view_model.dart';
import 'package:beast/src/ui/widgets/busy_button.dart';
import 'package:beast/src/ui/widgets/busy_overlay.dart';
import 'package:beast/src/ui/widgets/input_field.dart';
import 'package:beast/src/ui/widgets/text_link.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      builder: (
        BuildContext context,
        SignUpViewModel model,
        Widget child,
      ) {
        return BusyOverlay(
          show: model.isBusy,
          child: Scaffold(
            backgroundColor: Config.blackColor,
            body: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: blockSizeVertical(context) * 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: blockSizeVertical(context) * 5,
                            fontWeight: FontWeight.bold,
                            color: Config.whiteColor,
                          ),
                        ),
                        SizedBox(
                          height: blockSizeVertical(context) * 15,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/icon_large.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceMedium(context),
                    InputField(
                      placeholder: 'Full Name',
                      controller: model.fullNameController,
                    ),
                    verticalSpaceSmall(context),
                    InputField(
                      placeholder: 'Username',
                      controller: model.usernameController,
                    ),
                    verticalSpaceSmall(context),
                    InputField(
                      placeholder: 'Email',
                      controller: model.emailController,
                    ),
                    verticalSpaceSmall(context),
                    InputField(
                      placeholder: 'Password',
                      password: true,
                      controller: model.passwordController,
                      additionalNote:
                          'Password has to be a minimum of 6 characters.',
                    ),
                    verticalSpaceSmall(context),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BusyButton(
                          title: 'Sign Up',
                          busy: model.isBusy,
                          onPressed: () async {
                            await model.signUp();
                          },
                        ),
                      ],
                    ),
                    verticalSpaceSmall(context),
                    TextLink(
                      'Have An Account? Login!',
                      color: Config.whiteColor,
                      onPressed: () {
                        model.navigateToLogin();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
