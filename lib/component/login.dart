import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_with_flutter/model/user.model.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var emailField = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        decoration: InputDecoration(hintText: "Email Adresse"),
        controller: _emailController,
        validator: (value) {
          if (value.isEmpty) {
            return "Please enter an valid email";
          } else {
            return "";
          }
        },
      ),
    );

    var passwordField = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        decoration: InputDecoration(hintText: "Password"),
        controller: _passwordController,
        validator: (value) {
          if (value.isEmpty) {
            return "Please enter a password";
          } else {
            return "";
          }
        },
      ),
    );

    var loginControl = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () {
          var userModel = Provider.of<UserModel>(context);
          var email = _emailController.text;
          var password = _passwordController.text;
          userModel.handleSignInWithEmail(email, password).then((user) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Welcome ${user.displayName}"),
              ),
            );
          }).catchError((error) {
            if (error is PlatformException)
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(error.message),
                ),
              );
          });
        },
        child: Text("Login"),
      ),
    );

    var registerControl = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () {
          print("Register pressed");
        },
        child: Text("Register"),
      ),
    );

    var loginWithGoogleService = RaisedButton(
      onPressed: () {
        var userModel = Provider.of<UserModel>(context);
        userModel.handleSignInWithGoogle().then((user) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Welcome ${user.displayName}"),
            ),
          );
        }).catchError((error) {
          if (error is PlatformException)
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(error.message),
              ),
            );
        });
      },
      child: Text(
        "Login with Google Service",
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.lightBlue,
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          emailField,
          passwordField,
          loginControl,
          registerControl,
          loginWithGoogleService
        ],
      ),
    );
  }
}
