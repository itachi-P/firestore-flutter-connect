import 'package:flutter/material.dart';

import 'facebook_login_process.dart';
import 'google_login_process.dart';
import 'mail_login_form.dart';

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
            padding: EdgeInsets.all(16.0),
            child: Text('----------'),
          ),
          GoogleLoginProcess(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('----------'),
          ),
          FacebookLoginProcess(),
        ],
      ),
    );
  }
}
