import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final emailAddressController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final emailAddress = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        decoration: InputDecoration(hintText: "Email Adresse"),
        controller: emailAddressController,
        validator: (value) {
          if (value.isEmpty) {
            return "Please enter an valid email";
          }
        },
      ),
    );

    final passwordField = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        decoration: InputDecoration(hintText: "Password"),
        controller: passwordController,
        validator: (value) {
          if (value.isEmpty) {
            return "Please enter a password";
          }
        },
      ),
    );

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _handleSignInWithEmail(
              emailAddressController.text,
              passwordController.text,
            ).then((FirebaseUser user) {
              // TODO: We want to navigate to another view -> Homepage
              if (user.displayName == null) {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("Welcome back!")));
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Welcome back ${user.displayName}!")));
              }
            }).catchError((error) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text(error.message)));
            });
          } else {
            print('Data are invalid');
          }
        },
        child: Text("Login"),
      ),
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // TODO: Insert some spacing
          emailAddress,
          passwordField,
          loginButton,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // TODO: Show a second Password field
                print("Register pressed");
              },
              child: Text("Register"),
            ),
          )
        ],
      ),
    );
  }

  // TODO: _handleNewUsers()

  Future<FirebaseUser> _handleSignInWithEmail(
    String email,
    String password,
  ) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }
}
