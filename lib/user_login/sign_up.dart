import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fireflutter/user_login/src/auth.dart';
import 'package:fireflutter/user_login/primary_button.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key, this.title, this.auth, this.onSignOut, this.onSignIn}) : super(key: key);
  final String title;
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final VoidCallback onSignIn;

  @override
  _SignUpState createState() => _SignUpState();
}

enum FormType {
  login,
  register
}

class _SignUpState extends State<SignUp> {
  static final formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _displayName = '';
  String _photoUrl = '';
  String _authHint = '';
  String _userId;

  bool isValidated() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void onPressSignIn() async {

    setState(() {
      _authHint = '';
      _userId = '';
    });
    widget.onSignOut();
  }


  void onPressSignUp() async {

    setState(() {
      _authHint = '';
      _userId = '';
    });

    if (isValidated()) {
      // Formエラーがない場合
      try {

        // Firebase: User Create.
        String userId = await widget.auth.createUser(_email, _password, _displayName, _photoUrl);

        setState(() {
          _authHint = 'Signed In\n\nUser id: $userId';
          print("userID: $userId");
          _userId = userId;
        });
        widget.onSignIn();
      }
      catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e);
      }
    }
  }

  // 入力フォーム
  List<Widget> usernameAndPassword() {
    return [
      padded(child: TextFormField(
        key: Key('displayName'),
        decoration: InputDecoration(labelText: 'Name'),
        autocorrect: false,
        validator: (value) => value.isEmpty ? 'Name can\'t be empty.' : null,
        onSaved: (value) => _displayName = value,
      )),
      padded(child: TextFormField(
        key: Key('email'),
        decoration: InputDecoration(labelText: 'Email'),
        autocorrect: false,
        validator: (value) => value.isEmpty ? 'Email can\'t be empty.' : null,
        onSaved: (value) => _email = value.trim(),
      )),
      padded(child: TextFormField(
        key: Key('password'),
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        autocorrect: false,
        validator: (value) => value.isEmpty ? 'Password can\'t be empty.' : null,
        onSaved: (value) => _password = value.trim(),
      )),
    ];
  }

  // ボタン
  List<Widget> submitWidgets() {
    return [
      PrimaryButton(
          key: Key('register'),
          text: 'サインアップ',
          height: 44.0,
          onPressed: onPressSignUp
      ),
      FlatButton(
          key: Key('login'),
          textColor: Colors.green,
          child: Text("既にアカウントをお持ちの方：サインイン"),
          onPressed: onPressSignIn
      ),
    ];
  }

  Widget hintText() {
    return Container(
      //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: Text(
            _authHint,
            key: Key('hint'),
            style: TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                children: [
                  Card(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                                padding: const EdgeInsets.all(16.0),
                                child: Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: usernameAndPassword() + submitWidgets(),
                                    )
                                )
                            ),
                          ])
                  ),
                  hintText()
                ]
            )
        ))
    );
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}