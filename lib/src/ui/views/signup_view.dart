import 'package:beast/src/constants/config.dart';
import 'package:beast/src/ui/shared/ui_helpers.dart';
import 'package:beast/src/ui/widgets/busy_button.dart';
import 'package:beast/src/ui/widgets/input_field.dart';
import 'package:beast/src/ui/widgets/text_link.dart';
import 'package:beast/src/viewmodels/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SignUpViewModel>.withConsumer(
      viewModel: SignUpViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Config.blackColor,
          body: Center(
            child: AbsorbPointer(
              absorbing: model.busy ? true : false,
              child: Opacity(
                opacity: model.busy ? 0.5 : 1.0,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth(context) * 0.1,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: screenWidth(context) * 0.1,
                                fontWeight: FontWeight.bold,
                                color: Config.whiteColor,
                              ),
                            ),
                            SizedBox(
                              height: screenWidth(context) * 0.3,
                              child: ClipOval(
                                child:
                                    Image.asset('assets/images/icon_large.png'),
                              ),
                            ),
                          ],
                        ),
                        verticalSpaceLarge,
                        InputField(
                          placeholder: 'Full Name',
                          controller: model.fullNameController,
                        ),
                        verticalSpaceSmall,
                        InputField(
                          placeholder: 'Username',
                          controller: model.usernameController,
                        ),
                        verticalSpaceSmall,
                        InputField(
                          placeholder: 'Email',
                          controller: model.emailController,
                        ),
                        verticalSpaceSmall,
                        InputField(
                          placeholder: 'Password',
                          password: true,
                          controller: model.passwordController,
                          additionalNote:
                              'Password has to be a minimum of 6 characters.',
                        ),
                        verticalSpaceMedium,
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BusyButton(
                              title: 'Sign Up',
                              busy: model.busy,
                              onPressed: () {
                                model.signUp();
                              },
                            ),
                          ],
                        ),
                        verticalSpaceMedium,
                        TextLink(
                          'Have An Account? Login!',
                          onPressed: () {
                            model.navigateToLogin();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
