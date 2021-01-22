import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sid_db_ex1/task.dart';

import 'db_provider.dart';

// (17)

class TaskUpdateView extends StatefulWidget {
  Task task;

  TaskUpdateView(Task task) {
    this.task = task;
  }

  @override
  State<StatefulWidget> createState() => TaskUpdateViewState();
}

class TaskUpdateViewState extends State<TaskUpdateView> {
  String inputValue = "";

  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = new TextEditingController(text: widget.task.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            controller: _textEditingController,
            onChanged: (value) {
              inputValue = value;
            },
            onEditingComplete: () {},
          ),
          FlatButton(
            child: Text("Update"),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              print(inputValue);
              DBProvider()
                  .updateTask(widget.task.id,
                      Task(id: widget.task.id, name: this.inputValue))
                  .then((int result) {
                Navigator.of(context).pop();
              });
            },
          ),
        ],
      ),
    );
  }
}
