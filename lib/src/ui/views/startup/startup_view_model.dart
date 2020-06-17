import 'dart:async';

import 'package:beast/src/app/generated/router/router.gr.dart';
import 'package:beast/src/ui/global/custom_base_view_model.dart';

class StartupViewModel extends CustomBaseViewModel {
  Future handleStartUpLogic() async {
    bool hasLoggedInUser = await authenticationService.isUserLoggedIn();

    if (hasLoggedInUser) {
      navigateToHomeView();
    } else {
      navigateToLoginView();
    }
  }

  Future navigateToHomeView() async {
    await navigationService.pushNamedAndRemoveUntil(Routes.homeViewRoute);
  }

  Future navigateToLoginView() async {
    await navigationService.pushNamedAndRemoveUntil(Routes.loginViewRoute);
  }
}
