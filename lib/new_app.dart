import 'package:flutter/material.dart';

class NewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('新しいアプリの本体')),
      body: Center(
        child: Text(
          'アプリのスタートページ（仮）',
          style: TextStyle(fontSize: 25, color: Colors.greenAccent),
        ),
      ),
    );
  }
}
