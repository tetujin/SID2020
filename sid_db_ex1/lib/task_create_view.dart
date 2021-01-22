import 'package:flutter/material.dart';

import 'db_provider.dart';

// (11) make a task create view (as a Statefulwidget)

class TaskCreateView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TaskCreateViewState();
}

class TaskCreateViewState extends State<TaskCreateView> {
  String inputValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // Text Filed
          TextField(
            onChanged: (value) {
              inputValue = value;
            },
            onEditingComplete: () {},
          ),
          // Button
          FlatButton(
            child: Text("Add"),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              // add a new task when the `Add` button is pushed
              DBProvider().addTask(inputValue).then((int result) {
                print(result);
                Navigator.of(context).pop();
              });
            },
          ),
        ],
      ),
    );
  }
}
