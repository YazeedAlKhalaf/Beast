import 'package:beast/src/constants/config.dart';
import 'package:beast/src/ui/shared/ui_helpers.dart';
import 'package:beast/src/ui/widgets/busy_button.dart';
import 'package:beast/src/ui/widgets/input_field.dart';
import 'package:beast/src/ui/widgets/text_link.dart';
import 'package:beast/src/viewmodels/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LoginViewModel>.withConsumer(
      viewModel: LoginViewModel(),
      builder: (
        BuildContext context,
        LoginViewModel model,
        Widget child,
      ) {
        return Scaffold(
          backgroundColor: Config.blackColor,
          body: AbsorbPointer(
            absorbing: model.busy ? true : false,
            child: Opacity(
              opacity: model.busy ? 0.5 : 1,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth(context) * 0.1,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
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
                      controller: emailController,
                    ),
                    verticalSpaceSmall,
                    InputField(
                      placeholder: 'Password',
                      password: true,
                      controller: passwordController,
                    ),
                    verticalSpaceMedium,
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BusyButton(
                          title: 'Login',
                          busy: model.busy,
                          onPressed: () {
                            model.login(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          },
                        )
                      ],
                    ),
                    verticalSpaceMedium,
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
