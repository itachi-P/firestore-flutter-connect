import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'user_login/src/auth.dart';
import 'user_login/sign_in.dart';
import 'user_login/sign_up.dart';
import 'change_habit.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Login',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: RootPage(auth: Auth()),
    );
  }
}

class RootPage extends StatefulWidget {
  RootPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;
  final userRef = Firestore.instance.collection('change-habit');

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

// 状態定義 ↓ (01) 認証状態と画面情報定義
enum AuthStatus { notSignedIn, signedIn, signUp }

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  String _userId;

  @override
  initState() {
    //final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
    super.initState();
    print("In initState.");

    // Firebase 認証 ↓ (02) カレントユーザ情報取得
    widget.auth.currentUser().then((userId) {
      print("userId in initState(): $userId");
      setState(() {
        authStatus =
        userId != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
      });
    });
  }

  // 認証状態更新 ↓ (03)Stateを更新する処理
  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 認証状態に応じて表示する画面を分ける ↓ (04)画面制御処理
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        print('■ サインイン');
        // サインインページ
        return SignIn(
          title: 'Flutter Firebase SignIn',
          auth: widget.auth,
          onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
          onSignUp: () => _updateAuthStatus(AuthStatus.signUp),
        );
      case AuthStatus.signedIn:
        // アプリ本体スタート画面
        print('■ Change habits');
        // ログイン状態であればまずFirestoreにデータが有るかを見に行く
        setState(() {
          //

        });
        //FirebaseAuth.instance.currentUser().then((userId) => _userId);
        FirebaseUser user;
        widget.auth.currentUser().then((value) => user);
        print("_userId: $user");
        widget.userRef.document(_userId).snapshots().listen((snapshot) {
          if (snapshot != null) {
            print("_userId: $_userId");
            print("snapshot: ${snapshot.data}");
          } else {
            print("No data!");
            widget.userRef.document(_userId).setData(
                {
                  'name': 'new user',
                  'createDay': DateTime.now(),
                }
            );
          };
        });
        return ChangeHabit(
          auth: widget.auth,
          onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn),
        );
        break;
      //case AuthStatus.signUp:
      default:
        print('■ サインアップ');
        // 新規登録ページ
        return SignUp(
            title: 'Flutter Firebase SignUp',
            auth: widget.auth,
            onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn),
            onSignIn: () => _updateAuthStatus(AuthStatus.signedIn));
    }
  }
}
