import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/pages/utils/dialog_box.dart';
import 'package:todo_app/pages/utils/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //refrence the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  // text controller
  final _controller = TextEditingController();

  //if this fisrt time opeing the app
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //if this first time ever opeing the app, then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      //ALready exist data
      db.loadData();
    }
  }

  //Checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

//Save new Task
  void saveNewText() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  //Create new Task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewText,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  //delte task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        shadowColor: Colors.black,
        backgroundColor: Colors.yellow[400],
        centerTitle: true,
        title: Text("TO DO"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNewTask();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.yellow,
        shape: CircleBorder(side: BorderSide.none, eccentricity: 0.5),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => {checkBoxChanged(value, index)},
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
