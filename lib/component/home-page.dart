import 'package:flutter/material.dart';
import 'package:login_with_flutter/component/login.dart';
import 'package:login_with_flutter/component/todo-list-page.dart';
import 'package:login_with_flutter/model/user.model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: Scaffold(appBar: AppBar(
        title: Consumer<UserModel>(
          builder: (BuildContext context, UserModel userModel, Widget child) {
            return Text(userModel.status == Status.Authenticated
                ? "Todo List"
                : "Login Page");
          },
        ),
      ), body: Consumer<UserModel>(
        builder: (BuildContext context, UserModel userModel, Widget child) {
          if (userModel.status == Status.Authenticated) {
            return TodoListPage();
          }
          return LoginPage();
        },
      )),
      builder: (BuildContext context) => UserModel(),
    );
  }
}
