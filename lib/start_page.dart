import 'package:flutter/material.dart';
import 'user_login/src/auth.dart';

class GoalSetting extends StatefulWidget {
  GoalSetting({Key key, this.auth, this.onSignOut, this.currentPageGoalSet})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final VoidCallback currentPageGoalSet;

  @override
  _GoalSettingState createState() => _GoalSettingState();
}

class _GoalSettingState extends State<GoalSetting> {
  final _formKey = GlobalKey<FormState>();

  String _goal; // 習慣化したい目標・変えたい習慣
  String _achievement;  // 上記を習慣化する為の1日ごとの目標設定（良・可・不可の3段階）
  String _passing;
  String _failing;

  @override
  Widget build(BuildContext context) {
    void _signOut() async {
      try {
        await widget.auth.signOut();
        widget.onSignOut();
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Habits'),
        actions: <Widget>[
          FlatButton(
              onPressed: _signOut,
              child: Text('サインアウト',
                  style: TextStyle(fontSize: 17.0, color: Colors.white)))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: inputForm(),
            ),
          ),
        ),
      ),
    );
  }

  // 入力フォーム
  List<Widget> inputForm() {
    return [
      padded(
          child: Text(
        '３０日間で身に付けたい習慣を設定しましょう',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 17, color: Colors.cyan),
      )),
      padded(
          child: TextFormField(
        autofocus: true,
        key: Key('習慣'),
        decoration: InputDecoration(
          labelText: '習慣',
          hintText: '身に付けたい習慣を入力してください',
          border: OutlineInputBorder(),
        ),
        autocorrect: false,
        //initialValue: _goal = 'aaa',
        validator: (value) => value.isEmpty ? '習慣は必須入力です' : null,
        onSaved: (String value) => _goal = value,
        keyboardType: TextInputType.text,
      )),
      padded(
          child: TextFormField(
        key: Key('最高目標'),
        decoration: InputDecoration(labelText: '最高目標'),
        autocorrect: false,
        validator: (value) => value.isEmpty ? '最高目標を入力してください' : null,
        onSaved: (value) => _achievement = value,
      )),
      padded(
          child: TextFormField(
        key: Key('最低目標'),
        decoration: InputDecoration(labelText: '最低目標'),
        autocorrect: false,
        validator: (value) => value.isEmpty ? '最低目標を指定してください' : null,
        onSaved: (value) => _passing = value,
      )),
      padded(
          child: TextFormField(
        key: Key('不可条件'),
        decoration: InputDecoration(labelText: '不可条件'),
        autocorrect: false,
        validator: (value) => value.isEmpty ? '不可条件を指定してください' : null,
        onSaved: (value) => _failing = value,
      )),
      padded(
        child: RaisedButton(
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              setState(() {
                // 4つの入力値をStateに保持
                _formKey.currentState.save();

              });
              print('目的: $_goal'
                  '\n最高目標: $_achievement \n最低目標: $_passing \n不可条件: $_failing');
              // ページセット
              await widget.currentPageGoalSet();
            }
          },
          child: Text('登録する'),
        ),
      ),
    ];
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
