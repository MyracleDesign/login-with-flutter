import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
          var email = _emailController.text;
          var password = _passwordController.text;
          _handleSignInWithEmail(email, password).then((user) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Welcome ${user.displayName}"),
              ),
              // TODO: We navigate to a next page
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
        _handleSignInWithGoogle().then((user) {
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

  Future<FirebaseUser> _handleSignInWithEmail(
    String email,
    String password,
  ) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<FirebaseUser> _handleSignInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user;
  }
}
