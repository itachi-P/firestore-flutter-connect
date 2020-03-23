import 'package:flutter/material.dart';
import 'user_login/src/auth.dart';
//import 'habit_calendar.dart';
//import 'goal_setting.dart';

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
                        // 4つの入力値をStateに保持
                        _formKey.currentState.save();
                        // 30日カレンダー画面に切り替え
                        _goalSet = true;
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
    List _grading = ["良", "可", "不可"];
    String _selectedItem;

    List<DropdownMenuItem<String>> getDropDownMenuItems() {
      List<DropdownMenuItem<String>> items = List();
      for (String city in _grading) {
        items.add(DropdownMenuItem(value: city, child: Text(city)));
      }
      return items;
    }

//  // 支払方法変更処理
//  void changedDropDownItem(String selectedItem) {
//    setState(() {
//      _selectedItem = selectedItem;
//    });
//  }

//  // 入力フォーム
//  DropdownButtonHideUnderline dropdownMenu() {
//    return DropdownButtonHideUnderline(
//      child: ButtonTheme(
//        alignedDropdown: true,
//        child: DropdownButton(
//          key: Key('達成度'),
//          value: _selectedItem,
//          items: getDropDownMenuItems(),
//          onChanged: changedDropDownItem,
//        ),
//      ),
//    );
//  }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(
            '３０日チャレンジ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            "＜前のページで設定した習慣＞",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                backgroundColor: Colors.orange),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          HabitCalendar(context),
        ],
      ),
    );
  }

  Widget HabitCalendar(BuildContext context) {
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
            for (index = 1; index < 31; index++) DairyRecord(context, index)
          ]),
    );
  }

  Widget DairyRecord(BuildContext context, int index) {
    return Container(
      width: 50.0,
      height: 50.0,
      color: Colors.grey[400],
      child: InkWell(
        onTap: onTapDairyRecord(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: "labelText",
          ),
          baseStyle: TextStyle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("valueText", style: TextStyle()),
              Icon(Icons.arrow_drop_down,
                  color: Theme
                      .of(context)
                      .brightness == Brightness.light
                      ? Colors.grey.shade700
                      : Colors.white70),
            ],
          ),
        ),

        //child: Text(index.toString()),
      ),
    );
  }

  onTapDairyRecord(BuildContext context) {
    print("onTap called.");
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('段階評価'),
          content: Text('ここで３段階評価（色分け）を選択'),
          actions: <Widget>[
            FlatButton(
              child: Text('決定'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
}