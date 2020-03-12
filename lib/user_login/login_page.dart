import 'package:flutter/material.dart';

import 'mail_login_form.dart';
import 'sns_login.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Various login tests')),
      body: Column(
        children: <Widget>[
          MailAndPassLogin(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('----------'),
          ),
          SnsLogin(),
        ],
      ),
    );
  }
}
