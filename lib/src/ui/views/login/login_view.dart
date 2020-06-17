import 'package:beast/src/app/constants/config.dart';
import 'package:beast/src/ui/global/ui_helpers.dart';
import 'package:beast/src/ui/views/login/login_view_model.dart';
import 'package:beast/src/ui/widgets/busy_button.dart';
import 'package:beast/src/ui/widgets/busy_overlay.dart';
import 'package:beast/src/ui/widgets/text_link.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:beast/src/ui/widgets/input_field.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (
        BuildContext context,
        LoginViewModel model,
        Widget child,
      ) {
        return BusyOverlay(
          show: model.isBusy,
          child: Scaffold(
            backgroundColor: Config.blackColor,
            body: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth(context) * 0.1,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: screenWidth(context) * 0.3,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/icon_large.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenWidth(context) * 0.05,
                    ),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: screenWidth(context) * 0.1,
                        fontWeight: FontWeight.bold,
                        color: Config.whiteColor,
                      ),
                    ),
                    SizedBox(
                      height: screenWidth(context) * 0.15,
                    ),
                    InputField(
                      placeholder: 'Email',
                      controller: model.emailController,
                    ),
                    verticalSpaceSmall(context),
                    InputField(
                      placeholder: 'Password',
                      password: true,
                      controller: model.passwordController,
                    ),
                    verticalSpaceMedium(context),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BusyButton(
                          title: 'Login',
                          busy: model.isBusy,
                          onPressed: () async {
                            await model.login();
                          },
                        )
                      ],
                    ),
                    verticalSpaceMedium(context),
                    TextLink(
                      'Have no account? Create one now!',
                      color: Config.whiteColor,
                      onPressed: () {
                        model.navigateToSignUp();
                      },
                    )
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
