import 'package:flutter/material.dart';
import 'user_login/src/auth.dart';
//import 'habit_calendar.dart';
//import 'goal_setting.dart';
import 'daily_record.dart';

class ChangeHabit extends StatefulWidget {
  ChangeHabit({Key key, this.auth, this.onSignOut}) : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignOut;

  @override
  _ChangeHabitState createState() => _ChangeHabitState();
}

class _ChangeHabitState extends State<ChangeHabit> {
  final _formKey = GlobalKey<FormState>();

  bool _goalSet = false;
  String _goal; // 習慣化したい目標・変えたい習慣
  String _achievement; // 上記を習慣化する為の1日ごとの目標設定（良・可・不可の3段階）
  String _passing;
  String _failing;
  List _grading;

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
              child: Text(
                'サインアウト',
                style: TextStyle(fontSize: 17.0, color: Colors.white),
              ),
            ),
          ],
        ),
        body: _goalSet ? habitCalendar() : goalSetting());
  }

  // 目標設定フォーム
  SingleChildScrollView goalSetting() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              padded(
                  child: Text(
                '３０日間で身に付けたい習慣を設定しましょう',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.cyan),
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
                ),
              ),
              padded(
                child: TextFormField(
                  key: Key('最高目標'),
                  decoration: InputDecoration(labelText: '最高目標'),
                  autocorrect: false,
                  validator: (value) => value.isEmpty ? '最高目標を入力してください' : null,
                  onSaved: (value) => _achievement = value,
                ),
              ),
              padded(
                child: TextFormField(
                  key: Key('最低目標'),
                  decoration: InputDecoration(labelText: '最低目標'),
                  autocorrect: false,
                  validator: (value) => value.isEmpty ? '最低目標を指定してください' : null,
                  onSaved: (value) => _passing = value,
                ),
              ),
              padded(
                child: TextFormField(
                  key: Key('不可条件'),
                  decoration: InputDecoration(labelText: '不可条件'),
                  autocorrect: false,
                  validator: (value) => value.isEmpty ? '不可条件を指定してください' : null,
                  onSaved: (value) => _failing = value,
                ),
              ),
              padded(
                child: RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        // 4つの入力値をStateに保持->(3/24)引数として渡すことにしたから不要か？
                        _formKey.currentState.save();
                        // 30日カレンダー画面に切り替え
                        _goalSet = true;
                        _grading = [_achievement, _passing, _failing];
                      });
                      print('目的: $_goal'
                          '\n最高目標: $_achievement \n最低目標: $_passing \n不可条件: $_failing');
                    }
                  },
                  child: Text('登録する'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }

  SingleChildScrollView habitCalendar() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(
            '３０日チャレンジ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: <Widget>[
              Text(
                '習慣化目標：',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  backgroundColor: Colors.blue),
              ),
              Text(
                _goal,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    backgroundColor: Colors.orange),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          HabitCalendar(),
        ],
      ),
    );
  }

  Widget HabitCalendar() {
    int index = 0;
    return Container(
      alignment: Alignment.center,
      color: Colors.grey[300],
      child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          spacing: 5.0,
          runSpacing: 20.0,
          children: <Widget>[
            for (index = 1; index < 31; index++) DairyRecord(index: index, grading: _grading)
          ]),
    );
  }

//  Widget DairyRecord(int index) {
//    return Container(
//      width: 50.0,
//      height: 50.0,
//      // TODO タップされたマスを一意に区別してその色を変えるように変更
//      key: ValueKey(index.toString()),
//      color: _selectedItem == null ? Colors.grey[400] : Colors.red,
//      child: InkWell(
//        onTap: _onTapDairyRecord,
//        child: Text(index.toString()),
//      ),
//    );
//  }
//
//  Future<void> _onTapDairyRecord() async {
//    print("onTap called.");
//
//    List<DropdownMenuItem<String>> getDropDownMenuItems() {
//      List<DropdownMenuItem<String>> items = List();
//      for (String item in _grading) {
//        items.add(DropdownMenuItem(value: item, child: Text(item)));
//      }
//      return items;
//    }
//
//    // 選択アイテム変更処理
//    void changedDropDownItem(String selectedItem) {
//      setState(() {
//        _selectedItem = selectedItem;
//        print("selected:" + _selectedItem);
//      });
//    }
//
//    // ドロップダウンメニュー入力フォーム
//    DropdownButtonHideUnderline dropdownMenu() {
//      return DropdownButtonHideUnderline(
//        child: ButtonTheme(
//          alignedDropdown: true,
//          child: DropdownButton(
//            key: Key('達成度'),
//            value: _selectedItem,
//            items: getDropDownMenuItems(),
//            onChanged: changedDropDownItem,
//          ),
//        ),
//      );
//    }
//
//    return showDialog<void>(
//      context: context,
//      // [false] user must tap button. [true] user can tap outside dialog.
//      barrierDismissible: false,
//      builder: (BuildContext dialogContext) {
//        return AlertDialog(
//          title: Text('段階評価'),
//          // TODO ここをプルダウンメニュー化し、選択したvalueによって色分けする。
//          content: SingleChildScrollView(
//            child: ListBody(
//              children: <Widget>[
//                dropdownMenu(),
//              ],
//            ),
//          ),
//          actions: <Widget>[
//            FlatButton(
//              child: Text('決定'),
//              onPressed: () {
//                Navigator.of(dialogContext)
//                    .pop(_selectedItem); // Dismiss alert dialog
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }
}
