import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status { Authenticated, Unauthenticated, Authorising }

class UserModel extends ChangeNotifier {
  final _googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;

  FirebaseUser user;
  Status status;

  UserModel() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      status = account == null ? Status.Unauthenticated : Status.Authenticated;
      notifyListeners();
    });

    _auth.onAuthStateChanged.listen((firebaseUser) {
      if (firebaseUser == null) {
        status = Status.Unauthenticated;
      } else {
        user = firebaseUser;
        status = Status.Authenticated;
        notifyListeners();
      }
    });
  }

  Future<FirebaseUser> handleSignInWithEmail(
    String email,
    String password,
  ) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<FirebaseUser> handleSignInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    var credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> handleLogOut() async {
    _auth.signOut();
    _googleSignIn.signOut();
  }
}
