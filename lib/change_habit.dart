import 'package:flutter/material.dart';
import 'user_login/src/auth.dart';
//import 'habit_calendar.dart';
//import 'goal_setting.dart';
import 'daily_record.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeHabit extends StatefulWidget {
  ChangeHabit({Key key, this.auth, this.onSignOut, this.userId, this.displayName}) : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final String userId;
  final String displayName;

  @override
  _ChangeHabitState createState() => _ChangeHabitState();
}

class _ChangeHabitState extends State<ChangeHabit> {
  final _formKey = GlobalKey<FormState>();

  bool _isGoalSet = false;
  String _settingGoal; // 習慣化したい目標・変えたい習慣
  String _achievement; // 上記を習慣化する為の1日ごとの目標設定（良・可・不可の3段階）
  String _passing;
  String _failure;
  List _grading;  // 上記三段階評価の文字列を纏めたリスト

  @override
  Widget build(BuildContext context) {
    void _signOut() async {
      try {
        await widget.auth.signOut();
        widget.onSignOut();
        print('■ ログアウトしたよ。');
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.displayName}さん',
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 18.0,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: _signOut,
              child: Text(
                'ログアウト',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ],
        ),
        body: _isGoalSet ? habitCalendar() : goalSetting());
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
                  //initialValue: _settingGoal = 'aaa',
                  validator: (value) => value.isEmpty ? '習慣は必須入力です' : null,
                  onSaved: (String value) => _settingGoal = value,
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
                  onSaved: (value) => _failure = value,
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
                        _isGoalSet = true;
                        _grading = [_achievement, _passing, _failure];
                        Firestore.instance.collection('change-habit').document(widget.userId).collection('set-goal_001').document('targets').setData({
                          'setting-goal': _settingGoal,
                          'achievement': _achievement,
                          'passing': _passing,
                          'failure': _failure,
                          'create-day': DateTime.now().toIso8601String(),
                        });
                      });
                      print('目的: $_settingGoal'
                          '\n最高目標: $_achievement \n最低目標: $_passing \n不可条件: $_failure');
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
                _settingGoal,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Stream<List> streamList = _buildList(context);
                  Future<List> list = streamList.first;
                  list.then((value) => print("value: ${value.first.document_id}"));
                },
                child: Text("読み込み"),
              ),
              RaisedButton(
                onPressed: () {},
                child: Text("書き込み"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildList(BuildContext context) {
    return Firestore.instance.collection('change-habit').snapshots().map((data) =>
        data.documents.map((data) => _buildListItem(context, data)).toList());
  }

  _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return record;
  }

  Widget HabitCalendar() {
    int index = 0;
    Firestore.instance.collection('change-habit').document(widget.userId).collection('set-goal_001').document('30days-record').snapshots().listen((snapshot) async {
      if(snapshot.exists) {
        await print("snapshot2: ${snapshot.data}");
      }
    });
    return Container(
      alignment: Alignment.center,
      color: Colors.grey[300],
      child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          spacing: 5.0,
          runSpacing: 20.0,
          children: <Widget>[
            for (index = 1; index < 31; index++)
              DairyRecord(index: index, grading: _grading)
          ]),
    );
  }
}

class Record {
  final String document_id;
  //final String full_name;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(reference.documentID != null),
        //assert(map['full_name'] != null),
        document_id = reference.documentID;
        //full_name = map['full_name'],

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}