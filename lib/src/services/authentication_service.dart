import 'package:beast/src/locator.dart';
import 'package:beast/src/models/user.dart';
import 'package:beast/src/services/firestore_service.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _currentUser;
  User get currentUser => _currentUser;

  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _populateCurrentUser(authResult.user);
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullName,
    @required String username,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      List<String> friends = <String>[];

      // create a new user profile on firestore
      _currentUser = User(
        uid: authResult.user.uid,
        email: email,
        fullName: fullName,
        username: username,
        friends: friends,
      );
      await _firestoreService.createUser(_currentUser);

      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future<bool> isUserLoggedIn() async {
    var user = await _firebaseAuth.currentUser();
    await _populateCurrentUser(user);
    return user != null ? true : false;
  }

  Future _populateCurrentUser(FirebaseUser user) async {
    try {
      if (user != null) {
        _currentUser = await _firestoreService.getUser(user);
      }
    } catch (e) {
      print('e ' + e.message);
    }
  }

  Future populateCurrentUser(FirebaseUser user) async {
    try {
      if (user != null) {
        _currentUser = await _firestoreService.getUser(user);
      }
    } catch (e) {
      print('e ' + e.message);
    }
  }

  // getCurrentUser() async {
  //   var user = await _firebaseAuth.currentUser();
  //   User currentUser = await _firestoreService.getUser(user);
  //   _currentUser = currentUser;
  // }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
