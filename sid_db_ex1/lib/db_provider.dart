import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sid_db_ex1/task.dart';
import 'package:sqflite/sqflite.dart';

// (2) Create a DBProvider
class DBProvider {
  // (3) create an initializer of DBProvider
  Future<Database> initDb() async {
    // get a path for the application's local storage
    Directory directory = await getApplicationDocumentsDirectory();
    // create a file path for the database
    final path = join(directory.path, "memos.db");
    // create database using the file path
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
              create table tasks (
                id INTEGER PRIMARY KEY AUTOINCREMENT, 
                name TEXT)''');
      },
    );
  }

  // (4) INSERT INTO Tasks(name) VALUES(?)
  Future<int> addTask(String taskName) async {
    final db = await initDb();
    return db.insert('tasks', {'name': taskName});
  }

  // (5) SELECT * FROM tasks
  Future<List<Task>> getTasks() async {
    final db = await initDb();
    final tasks = await db.query('tasks');
    return List.generate(tasks.length, (index) {
      return Task(
        id: tasks[index]['id'],
        name: tasks[index]['name'],
      );
    });
  }

  // (6) DELETE FROM tasks WHERE id = ?'
  Future<int> deleteTask(id) async {
    final db = await initDb();
    return await db.delete(
      'tasks',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // (7) UPDATE tasks SET id = ?, name = ? WHERE id = ?'
  Future<int> updateTask(int id, Task task) async {
    final db = await initDb();
    return db.update(
      "tasks",
      task.toMap(),
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
