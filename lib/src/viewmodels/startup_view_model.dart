import 'package:beast/src/constants/route_names.dart';
import 'package:beast/src/viewmodels/base_model.dart';

class StartUpViewModel extends BaseModel {
  Future handleStartUpLogic() async {
    bool hasLoggedInUser = await authenticationService.isUserLoggedIn();

    if (hasLoggedInUser) {
      navigationService.navigateToAndRemoveUntill(HomeViewRoute);
    } else {
      navigationService.navigateToAndRemoveUntill(LoginViewRoute);
    }
  }
}
