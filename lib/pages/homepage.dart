// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly/models/task.dart';

class Homepage extends StatefulWidget{

  const Homepage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _homepagestate();
  }
}

// ignore: camel_case_types
class _homepagestate extends State<Homepage> {

  String? _newtaskcontent;
  Box? _box;
  late double _deviceheight;
  // ignore: unused_field
  late double _devicewidth;

  _homepagestate();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceheight = MediaQuery.of(context).size.height;
    _devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        toolbarHeight: _deviceheight*0.10,
        title: const Text("Taskly!", style: TextStyle(
          fontSize: 30,
          color: Colors.white,
        ),),
      ),
      body: _taskView(),
      floatingActionButton: _addtaskbutton(),
    );
  }

  Widget _taskView() {
    Hive.openBox('tasks');
    return FutureBuilder(
      future: Hive.openBox('tasks'), 
      // ignore: duplicate_ignore
      // ignore: no_leading_underscores_for_local_identifiers
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if(_snapshot.hasData){
          _box = _snapshot.data;
          return _tasklist();
        }
        else{
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    });
  }

  Widget _tasklist() { //Scrollable list
  List tasks = _box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      // ignore: duplicate_ignore
      // ignore: no_leading_underscores_for_local_identifiers
      itemBuilder: (BuildContext _context, int _index) {
        var task = Task.fromMap(tasks[_index]);
        return ListTile(
            title: Text(task.content, style: TextStyle(decoration: !task.done ? null : TextDecoration.lineThrough)),
            subtitle: Text(task.timestamp.toString()),
            trailing: Icon(
              task.done ? Icons.check_box_outlined : Icons.check_box_outline_blank_outlined,
              color: Colors.red,
            ),
            onTap: () {
              task.done = !task.done;
              _box!.putAt(_index, task.toMap());
              setState(() {
                
              });
            },
            onLongPress: () {
              _box!.deleteAt(_index);
              setState(() {
                
              });
            },
          );
      });
    
  }

  Widget _addtaskbutton() {
    return FloatingActionButton(
      onPressed: _displaytaskpopup,
      backgroundColor: Colors.red,
      shape: const CircleBorder(),
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );

  }

  void _displaytaskpopup(){
    showDialog(
      context: context, 
      builder: (BuildContext _context) {
      return AlertDialog(
        title: const Text("Add new task!"),
        content: TextField(
          onSubmitted: (_) {
            if (_newtaskcontent != null){
              var _temptask = Task(content: _newtaskcontent!, timestamp: DateTime.now(), done: false);
              _box!.add(_temptask.toMap());
              setState(() {
                _newtaskcontent = null;
                Navigator.pop(_context);
              });
            }
          },
          onChanged: (_value) {
           setState(() {
            _newtaskcontent = _value;
           });
          },
        ),
      );
    });
  }

}