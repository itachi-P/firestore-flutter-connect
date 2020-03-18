import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> createUser(
      String email, String password, String displayName, String photoUrl);
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  // Login with email and password
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //final BaseUsers _users = new Users();

  Future<String> signIn(String email, String password) async {
    // Firebase Authentication サインイン
    AuthResult _result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = _result.user;

    return user.uid;
  }

  Future<String> createUser(String email, String password, String displayName,
      String photoUrl) async {
    // Firebase Authentication サインアップ→サインイン
    AuthResult _result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = _result.user;

    // Firebase UserInfo 更新　↓ (04) AuthenticationのuserInfo更新処理
    UserUpdateInfo info = UserUpdateInfo();
    info.displayName = displayName; // 表示名
    info.photoUrl = photoUrl; // 画像URL
    user.updateProfile(info);

    return user.uid;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user.uid : null;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
