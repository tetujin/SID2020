// (2) Add the following code ##

class Task {
  final int id;
  final String name;

  Task({this.id, this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
