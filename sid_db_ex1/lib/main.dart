import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sid_db_ex1/db_provider.dart';
import 'package:sid_db_ex1/task.dart';
import 'package:sid_db_ex1/task_create_view.dart';
import 'package:sid_db_ex1/task_update_view.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Task Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();

    // (8) get all tasks in the database
    DBProvider().getTasks().then((List<Task> tasks) {
      setState(() {
        this.tasks = tasks;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        // (12) Create ListView Builder -+-+-+-+--+-+-+-+-
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            // leading: Icon(Icons.check),
            title: Text(tasks[index].name),
            subtitle: Text('${tasks[index].id}'),
            trailing: Icon(Icons.arrow_forward_ios_sharp),
            onTap: () {
              // (13) Add a task control handler using `showDialog` ===========
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text(tasks[index].name),
                      content: Text("${tasks[index].id}"),
                      actions: <Widget>[
                        // (14) Delete action
                        FlatButton(
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            DBProvider().deleteTask(tasks[index].id);
                            Navigator.pop(context);
                            _refreshTasks();
                          },
                        ),
                        // (15) Update action
                        FlatButton(
                          child: Text(
                            "Update",
                            style: TextStyle(color: Colors.blue),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return TaskUpdateView(tasks[index]);
                              },
                            )).then((var result) {
                              Navigator.pop(context);
                              _refreshTasks();
                            });
                          },
                        ),
                        // (16) Complete action
                        FlatButton(
                            child: Text(
                              "Done",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              DBProvider().deleteTask(tasks[index].id);
                              Navigator.pop(context);
                              _refreshTasks();
                            })
                      ],
                    );
                  });
              // =========================================
            },
          );
        },
        // -+-+-+-+--+-+-+-+--+-+-+-+--+-+-+-+--+-+-+-+-
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // (9) move to a task create view using Navigator
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return TaskCreateView();
            },
          )).then((var result) {
            // (10) refresh tasks
            _refreshTasks();
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _refreshTasks() {
    DBProvider().getTasks().then((List<Task> tasks) {
      setState(() {
        this.tasks = tasks;
      });
    });
  }
}
