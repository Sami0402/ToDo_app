import 'package:hive/hive.dart';

class ToDoDataBase {
  // refrence the box
  final _myBox = Hive.box("mybox");

  // todo task list
  List toDoList = [];

  //run this method if user is 1st Time ever opeing the app
  void createInitialData() {
    toDoList = [
      ["Make tutorial", false],
      ["Do Exercise", false],
    ];
  }

  //load the data from database
  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

  //Update the data
  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
