import 'package:beast/src/locator.dart';
import 'package:beast/src/models/user.dart';
import 'package:beast/src/services/authentication_service.dart';
import 'package:beast/src/services/dialog_service.dart';
import 'package:beast/src/services/firestore_service.dart';
import 'package:beast/src/services/navigation_service.dart';
import 'package:beast/src/services/storage_service.dart';
import 'package:beast/src/utils/utilities.dart';
import 'package:flutter/widgets.dart';

class BaseModel extends ChangeNotifier {
  final AuthenticationService authenticationService =
      locator<AuthenticationService>();
  final NavigationService navigationService = locator<NavigationService>();
  final FirestoreService firestoreService = locator<FirestoreService>();
  final StorageService storageService = locator<StorageService>();
  final DialogService dialogService = locator<DialogService>();
  final Utils utils = locator<Utils>();

  User get currentUser => authenticationService.currentUser;
  String get userInitials => utils.getInitials(currentUser.fullName);

  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  void popCurrentContext() {
    navigationService.pop();
  }
}
