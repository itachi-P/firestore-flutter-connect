import 'package:flutter/material.dart';

SingleChildScrollView habitCalendar(BuildContext context) {
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
                color: Theme.of(context).brightness == Brightness.light
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
