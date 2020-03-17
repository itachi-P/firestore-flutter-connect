import 'package:flutter/material.dart';

//import 'user_login/login_page.dart';
import 'user_login/src/auth.dart';
import 'user_login/sign_in.dart';
import 'user_login/sign_up.dart';
import 'new_app.dart';
import 'added_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Login',
      theme: ThemeData(
        primarySwatch: Colors.orange,
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
  signedUp
}

// カレントページ ↓ (01) 認証状態と画面情報定義
enum CurrentPage {
  addedPage,
  newApp,
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

  // ダイアログ表示メソッド
  void _buildDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Message: $message"),
            actions: <Widget>[
              FlatButton(
                child: const Text('CLOSE'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              FlatButton(
                child: const Text('SHOW'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        }
    );
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
          onSignUp: () => _updateAuthStatus(AuthStatus.signedUp),
        );
      case AuthStatus.signedIn:
        switch (currentPage) {
          case CurrentPage.addedPage:
            print('■ 追加画面');
            // 追加画面
            return AddedPage(
                auth: widget.auth,
                onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn),
                currentPageDashboardSet: () => _updateCurrentPage(CurrentPage.newApp)
            );
          default:
            print('■ Change habits');
            // アプリ本体スタート画面
            return NewApp(
                auth: widget.auth,
                onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn),
                currentPageClaimSet: () => _updateCurrentPage(CurrentPage.addedPage)
            );
        }
        break;
      case AuthStatus.signedUp:
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
