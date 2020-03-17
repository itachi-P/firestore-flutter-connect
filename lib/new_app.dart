import 'package:flutter/material.dart';
import 'user_login/src/auth.dart';

class NewApp extends StatelessWidget {
  NewApp({this.auth, this.onSignOut, this.currentPageClaimSet});
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final VoidCallback currentPageClaimSet;

  @override
  Widget build(BuildContext context) {

    void _signOut() async {
      try {
        await auth.signOut();
        onSignOut();
      } catch (e) {
        print(e);
      }

    }

    // 登録ボタン
    void onPressedClaimCreate() async {
      // ページセット
      currentPageClaimSet();
    }

    // 取得ボタン
    void onPressedClaimSelect() async {
      print('>>> Click：onCallClaimsSelect');
      final dynamic resp = 'onCallClaimsSelect';
      print(resp);
    }

    return new Scaffold(
      appBar: AppBar(
        title: Text('start page'),
        actions: <Widget>[
          FlatButton(
              onPressed: _signOut,
              child: Text('サインアウト', style: TextStyle(fontSize: 17.0, color: Colors.white))
          )
        ],
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
          child: RaisedButton(
            child: const Text('データ取得'),
            color: Theme.of(context).accentColor,
            elevation: 4.0,
            splashColor: Colors.blueGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            onPressed: onPressedClaimSelect,
          ),
        ),
      ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onPressedClaimCreate,
        label: Text("登録する"),
        icon: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}