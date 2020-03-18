import 'package:flutter/material.dart';
import 'primary_button.dart';
import 'src/auth.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key, this.title, this.auth, this.onSignIn, this.onSignUp})
      : super(key: key);
  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  static final formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _authHint = '';

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _authHint = '';
    });

    if (validateAndSave()) {
      // Formエラーがない場合
      try {
        String userId = await widget.auth.signIn(_email, _password);
        setState(() {
          _authHint = 'Signed In\n\nUser id: $userId';
        });
        widget.onSignIn();
      } catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e);
      }
    }
  }

  void signUpSubmit() async {
    setState(() {
      _authHint = '';
    });
    widget.onSignUp();
  }

  // 入力フォーム
  List<Widget> usernameAndPassword() {
    return [
      padded(
          child: TextFormField(
        key: Key('email'),
        decoration: InputDecoration(labelText: 'Email'),
        autocorrect: false,
        validator: (value) => value.isEmpty ? 'Email can\'t be empty.' : null,
        onSaved: (value) => _email = value.trim(),
      )),
      padded(
          child: TextFormField(
        key: Key('password'),
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        autocorrect: false,
        validator: (value) =>
            value.isEmpty ? 'Password can\'t be empty.' : null,
        onSaved: (value) => _password = value.trim(),
      )),
    ];
  }

  // ボタン
  List<Widget> submitWidgets() {
    return [
      PrimaryButton(
        key: Key('login'),
        text: 'サインイン',
        height: 44.0,
        onPressed: validateAndSubmit,
      ),
      FlatButton(
        key: Key('need-account'),
        textColor: Colors.green,
        child: Text("初めて利用する方：サインアップ"),
        onPressed: signUpSubmit,
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
          title: Text(widget.title),
        ),
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText()
                ]))));
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
