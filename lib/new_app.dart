import 'package:flutter/material.dart';
import 'user_login/src/auth.dart';

class NewApp extends StatefulWidget {
  NewApp({Key key, this.auth, this.onSignOut, this.currentPageClaimSet}) : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final VoidCallback currentPageClaimSet;
  @override
  _NewAppState createState() => _NewAppState();
}

class _NewAppState extends State<NewApp> {

  String _goal;
  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {

    void _signOut() async {
      try {
        await widget.auth.signOut();
        widget.onSignOut();
      } catch (e) {
        print(e);
      }
    }

    // 登録ボタン
    void onPressedGoalSetting() async {
      // ページセット
      widget.currentPageClaimSet();
    }
    // ダイアログを表示するメソッド
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

    String _setGoal(String value) {
      print('value: $value');
      setState(() {
        _goal = value;
      });
      return _goal;
    }
    // 目標設定ボタン
    void onPressedClaimSelect() async {
      // TODO ここを目標（String型）設定に変える
      print('>>> Click：$_goal onCallClaimsSelect');
      _buildDialog(context, "設定目標は$_goalです");
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Habits'),
        actions: <Widget>[
          FlatButton(
              onPressed: _signOut,
              child: Text('サインアウト', style: TextStyle(fontSize: 17.0, color: Colors.white))
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Text(
            '３０日間で達成したい目標を設定しましょう',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          ),
          TextField(
            controller: _controller,
            //key: Key('goal'),
            decoration: InputDecoration(
              labelText: '目標',
              border: OutlineInputBorder(),
            ),
            //autocorrect: false,
            onSubmitted: (String value) async {
              await _setGoal(value);
              },
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: RaisedButton(
              child: const Text('目標設定'),
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
        onPressed: onPressedGoalSetting,
        // TODO ここを目標に対する３段階の達成度合い登録機能（別ページに遷移）に変える
        label: Text("登録する"),
        icon: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
