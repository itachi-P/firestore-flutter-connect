import 'package:flutter/material.dart';

import 'new_app.dart';
import 'user_login/login_page.dart';
//import 'user_login/user_logged_in.dart';

// TODO 最終的に、ログイン状態であればログイン画面を飛ばしてアプリ本体画面に進むように変更
// ログイン状態かどうかを判定し、遷移先画面を決める
bool _loggedIn = false;
//UserLoggedIn _userLoggedIn = UserLoggedIn();

void main() {
  //final _loggedIn = _userLoggedIn.userLoggedIn();

  runApp(
    MaterialApp(
        title: 'Various login tests',
        home: _loggedIn ? NewApp() : LoginPage() // (仮)
    ),
  );
}