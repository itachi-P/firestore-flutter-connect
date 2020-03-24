import 'package:flutter/material.dart';

class DairyRecord extends StatefulWidget {
  DairyRecord({Key key, this.index, this.grading}) : super(key: key);

  final int index;
  final List grading;

  @override
  _DairyRecordState createState() => _DairyRecordState();
}

class _DairyRecordState extends State<DairyRecord> {
  Color _color;
  String _selectedItem;

  @override
  void initState() {
    super.initState();
    _color = Colors.grey[400];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      // TODO タップされたマスを一意に区別してその色を変えるように変更
      key: ValueKey(widget.index.toString()),
      color: _colorSelect(),
      child: InkWell(
        onTap: _onTapDairyRecord,
        child: Text(widget.index.toString()),
      ),
    );
  }

  Color _colorSelect() {
    Color color;
    if (_selectedItem == widget.grading[0]) {
      color = Colors.green;
    } else if (_selectedItem == widget.grading[1]) {
      color = Colors.blue;
    } else if (_selectedItem == widget.grading[2]) {
      color = Colors.red;
    } else
      color = Colors.grey[400];
    setState(() {
      _color = color;
    });
    return _color;
  }

  Future<void> _onTapDairyRecord() async {
    print("onTap called.");

    List<DropdownMenuItem<String>> getDropDownMenuItems() {
      List<DropdownMenuItem<String>> items = List();
      for (String item in widget.grading) {
        items.add(DropdownMenuItem(value: item, child: Text(item)));
      }
      return items;
    }

    // 選択アイテム変更処理
    void changedDropDownItem(String selectedItem) {
      setState(() {
        _selectedItem = selectedItem;
        print("selected:" + _selectedItem);
      });
    }

    // ドロップダウンメニュー入力フォーム
    DropdownButtonHideUnderline dropdownMenu() {
      return DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            key: Key('達成度'),
            value: _selectedItem,
            items: getDropDownMenuItems(),
            onChanged: changedDropDownItem,
          ),
        ),
      );
    }

    return showDialog<void>(
      context: context,
      // [false] user must tap button. [true] user can tap outside dialog.
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('段階評価'),
          // TODO ここをプルダウンメニュー化し、選択したvalueによって色分けする。
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                dropdownMenu(),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('決定'),
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(_selectedItem); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
}
