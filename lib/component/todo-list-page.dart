import 'package:flutter/material.dart';
import 'package:login_with_flutter/model/user.model.dart';
import 'package:provider/provider.dart';

class Todo {
  String currentTitle;
  bool currentValue;

  Todo(String title, bool value) {
    currentTitle = title;
    currentValue = value;
  }
}

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  var todoList = [
    Todo("Hello World", false),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RaisedButton(
          child: Text("Logout"),
          onPressed: () {
            Provider.of<UserModel>(context).handleLogOut();
          },
        ),
        Container(
          height: 500,
          child: ListView(
            children: todoList
                .map((todo) => CheckboxListTile(
                      value: todo.currentValue,
                      title: Text(todo.currentTitle ?? ""),
                      onChanged: (bool value) {
                        setState(() {
                          todo.currentValue = value;
                        });
                      },
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
