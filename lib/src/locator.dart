import 'package:beast/src/services/authentication_service.dart';
import 'package:beast/src/services/dialog_service.dart';
import 'package:beast/src/services/firestore_service.dart';
import 'package:beast/src/services/navigation_service.dart';
import 'package:beast/src/services/storage_service.dart';
import 'package:beast/src/utils/utilities.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => StorageService());
  locator.registerLazySingleton(() => Utils());
}
