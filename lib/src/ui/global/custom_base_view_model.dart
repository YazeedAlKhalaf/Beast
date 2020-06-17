import 'package:beast/src/app/generated/locator/locator.dart';
import 'package:beast/src/app/models/user.dart';
import 'package:beast/src/app/services/authentication_service.dart';
import 'package:beast/src/app/services/firestore_service.dart';
import 'package:beast/src/app/services/storage_service.dart';
import 'package:beast/src/app/utils/utils.dart';
import 'package:beast/src/ui/widgets/cached_image.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CustomBaseViewModel extends BaseViewModel {
  final AuthenticationService authenticationService =
      locator<AuthenticationService>();
  final NavigationService navigationService = locator<NavigationService>();
  final FirestoreService firestoreService = locator<FirestoreService>();
  final StorageService storageService = locator<StorageService>();
  final DialogService dialogService = locator<DialogService>();
  final Utils utils = locator<Utils>();

  User get currentUser => authenticationService.currentUser;
  String get userInitials => utils.getInitials(currentUser.fullName);

  displayProfileImage({User user}) {
    if (user.profilePhoto != null) {
      return CachedImage(
        url: user.profilePhoto,
      );
    } else {
      return null;
    }
  }

  void popCurrentContext() {
    navigationService.back();
  }
}
