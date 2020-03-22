import 'package:flutter/material.dart';
import 'user_login/src/auth.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.auth, this.onSignOut, this.currentPageDashboardSet, this.goal, this.achievement, this.failing, this.passing})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignOut;
  final VoidCallback currentPageDashboardSet;

  final String goal;
  final String achievement;
  final String passing;
  final String failing;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static final formKey = GlobalKey<FormState>();

  String _billingUid = '';
  DateTime _buyDate = DateTime.now(); // 開始日
  String _buyItem = ''; // 商品
  String _buyAmount = ''; // 購入金額
  List _payMethods = ["aaa", "bbb", "ccc"];
  String _currentPayMethod;

  String _authHint = '';

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = List();
    for (String city in _payMethods) {
      print("achievement: ${widget.achievement}");

      items.add(DropdownMenuItem(value: city, child: Text(city)));
    }
    return items;
  }

  void _signOut() async {
    try {
      widget.onSignOut();
    } catch (e) {
      print(e);
    }
  }

  void _dashboard() async {
    try {
      widget.currentPageDashboardSet();
    } catch (e) {
      print(e);
    }
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // 支払方法変更処理
  void changedDropDownItem(String selectedPayMethod) {
    setState(() {
      _currentPayMethod = selectedPayMethod;
    });
  }

  // 登録ボタン
  void onPressedGoalSetting() async {
    setState(() {
      _authHint = '';
    });

    if (validateAndSave()) {
      // Formエラーがない場合
      try {
        print('>>> Click：onPressdGoalSetting');
        print(_buyDate);
        print(_buyItem);
        print(_buyAmount);
        print(_currentPayMethod);
        // final dynamic resp = await CloudFunctions.instance.call(
        //                         functionName: 'onCallClaimsCreate',
        //                         parameters: <String, String> {
        //                           'buy_uid': _buyUid,
        //                           'buy_date': '2018-12-10',
        //                           'buy_item': _buyItem,
        //                           'buy_amount': '2100',
        //                           'pay_method': 'デビットカード',
        //                           'pay_status': '未',
        //                           'billing_amount': '750',
        //                           'billing_uid': _billingUid,
        //                           'created_at': '2018-12-12',
        //                           'updated_at': '2018-12-12'
        //                         },
        //                       );
        // print(resp);

      } catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e);
      }
    }
  }

  // 入力フォーム
  List<Widget> inputForm() {
    return [
      padded(
          child: TextFormField(
        key: Key('購入品'),
        decoration: InputDecoration(labelText: '購入品'),
        autocorrect: false,
        validator: (val) => val.isEmpty ? '購入品を入力してください' : null,
        onSaved: (val) => _buyItem = val,
      )),
      padded(
          child: TextFormField(
              key: Key('購入金額'),
              decoration: InputDecoration(labelText: '購入金額'),
              autocorrect: false,
              validator: (val) => val.isEmpty ? '購入金額を入力してください' : null,
              onSaved: (val) => _buyAmount = val,
              keyboardType: TextInputType.number)),
      padded(
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              key: Key('支払方法'),
              value: _currentPayMethod,
              items: getDropDownMenuItems(),
              onChanged: changedDropDownItem,
            ),
          ),
        ),
      ),
      padded(
        child: TextFormField(
          key: Key('請求先'),
          decoration: InputDecoration(labelText: '請求先'),
          autocorrect: false,
          initialValue: _billingUid,
          validator: (val) => val.isEmpty ? '請求先を指定してください' : null,
          onSaved: (val) => _billingUid = val,
        ),
      ),
    ];
  }

  Widget hintText() {
    return Container(
        //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: Text(_authHint,
            key: Key('hint'),
            style: TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('日々の目標設定'),
        actions: <Widget>[
          FlatButton(
              onPressed: _dashboard,
              child: Text('目的設定',
                  style: TextStyle(fontSize: 17.0, color: Colors.white))),
          FlatButton(
              onPressed: _signOut,
              child: Text('ログアウト',
                  style: TextStyle(fontSize: 17.0, color: Colors.white)))
        ],
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Card(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: inputForm(),
                        ))),
              ])),
              hintText()
            ])),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressedGoalSetting,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
