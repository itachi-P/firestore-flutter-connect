import 'package:flutter/material.dart';

import 'user_login/src/auth.dart';
import 'user_login/sign_in.dart';
import 'user_login/sign_up.dart';
import 'start_page.dart';
import 'main_page.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

// 状態定義 ↓ (01) 認証状態と画面情報定義
enum AuthStatus {
  notSignedIn,
  signedIn,
  signUp
}

// カレントページ ↓ (01) 認証状態と画面情報定義
enum CurrentPage {
  mainPage,
  goalSettingPage,
  other
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  CurrentPage currentPage = CurrentPage.other;

  @override
  initState() {
    //final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
    super.initState();

    // Firebase 認証 ↓ (02) カレントユーザ情報取得
    widget.auth.currentUser().then((userId) {
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

  // カレントページを更新 ↓ (03)Stateを更新する処理
  void _updateCurrentPage(CurrentPage page) {
    setState(() {
      currentPage = page;
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
        switch (currentPage) {
          case CurrentPage.mainPage:
            print('■ メイン画面');
            // メイン画面
            return MainPage(
                auth: widget.auth,
                onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn),
                currentPageDashboardSet: () => _updateCurrentPage(CurrentPage.goalSettingPage)
            );
          default:
            print('■ Change habits');
            // アプリ本体スタート画面
            return GoalSetting(
                auth: widget.auth,
                onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn),
                currentPageGoalSet: () => _updateCurrentPage(CurrentPage.mainPage)
            );
        }
        break;
      //case AuthStatus.signUp:
      default:
        print('■ サインアップ');
        // 新規登録ページ
        return SignUp(
            title: 'Flutter Firebase SignUp',
            auth: widget.auth,
            onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn),
            onSignIn: () => _updateAuthStatus(AuthStatus.signedIn)
        );
    }
  }

}
