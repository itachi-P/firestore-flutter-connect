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

  String _goal = '習慣化したい目標・変えたい習慣';
  String _good;
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

    // 登録ボタン
    void onPressedGoalSetting() async {
      print('設定値: $_goal $_good $_passing $_failing');
      setState(() {
        //_goal = value;
      });

      // ページセット
      widget.currentPageGoalSet();
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onPressedGoalSetting,
        // TODO ここを目標に対する３段階の達成度合い登録機能（別ページに遷移）に変える
        label: Text("登録する"),
        icon: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
        validator: (value) => value.isEmpty ? '新しい習慣を入力してください' : null,
        onSaved: (String value) => _goal = value,
        keyboardType: TextInputType.text,
      )),
      padded(
          child: TextFormField(
        key: Key('最高目標'),
        decoration: InputDecoration(labelText: '最高目標'),
        autocorrect: false,
        validator: (value) => value.isEmpty ? '最高目標を入力してください' : null,
        onSaved: (value) => _good = value,
      )),
      padded(
          child: TextFormField(
        key: Key('中間目標'),
        decoration: InputDecoration(labelText: '中間目標'),
        autocorrect: false,
        validator: (value) => value.isEmpty ? '中間目標を指定してください' : null,
        onSaved: (value) => _passing = value,
      )),
      padded(
          child: TextFormField(
        key: Key('最低目標'),
        decoration: InputDecoration(labelText: '最低目標'),
        autocorrect: false,
        validator: (value) => value.isEmpty ? '最低目標を指定してください' : null,
        onSaved: (value) => _failing = value,
      )),
      padded(
        child: RaisedButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              setState(() {
                // TODO 4つの入力値をStateに保持
                _formKey.currentState.save();
              });
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
