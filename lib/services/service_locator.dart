import 'package:get_it/get_it.dart';

import '../models/user/user_model.dart';
import 'firebase_auth_service.dart';
import 'firebase_firestore_service.dart';

GetIt locator = GetIt.I;

void setupLocator() async {
  //Singletons
  //locator.registerLazySingleton(() => SavedPreferencesService());

  //Factory
  locator.registerFactory(() => AuthService());
  locator.registerFactory(() => FirestoreService());

  //Models
  locator.registerLazySingleton(() => UserProfile());
}
