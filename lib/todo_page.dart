

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_tutorial/todo_form_page.dart';

import 'models/todo.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
      ),
      body: Column(
        children: [
          Expanded(child: _listView(),),
          TodoFormPage(),
        ],
      ),
    );
  }

  Widget _listView() {
    final todoBox = Hive.box('todos');
    return StreamBuilder(
      stream: todoBox.watch(),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: todoBox.length,
          itemBuilder: (context, index) {
            final todo = todoBox.getAt(index) as Todo;
            return InkWell(
              onTap: () {
                _updateDialogBox(context, todoBox, index);
              },
              onLongPress: () {
                _deleteDialogBox(context, todoBox, index);
              },
              child: Card(
                child: ListTile(
                  title: Text(todo.name),
                  subtitle: Text(todo.description),
                ),
              ),
            );
          },
        );
      }
    );
  }

  _updateDialogBox(BuildContext context, Box todoBox, int index) {
    final todo = todoBox.getAt(index) as Todo;
    var name;
    var desc;

    final _formKey = GlobalKey<FormState>();
    return showDialog(context: context, builder: (context) {
      return Dialog(
        child: Form(
          key: _formKey,
          child: Card(
            child: Column(
              children: [
                Text("Update Item"),
                SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Name",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    name = value;
                  },
                  initialValue: todo.name,
                ),
                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    desc = value;
                  },
                  initialValue: todo.description,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(onPressed: () { Navigator.pop(context); }, child: Text("Cancel")),
                    SizedBox(width: 10,),
                    ElevatedButton(onPressed: () {
                      Navigator.pop(context);
                      _formKey.currentState?.save();
                      final newUpdatedTodo = Todo(name: name, description: desc);
                      print("name : ${newUpdatedTodo.name}, desc : ${newUpdatedTodo.description}");
                      todoBox.putAt(index, newUpdatedTodo);
                    }, child: Text("Update"))
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  _deleteDialogBox(BuildContext context, Box todoBox, int index) {
    return showDialog(context: context, builder: (context) {
      return Dialog(
        child: Card(
          child: Column(
            children: [
              Text("Are you sure you want to delete this item?"),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(onPressed: () { Navigator.pop(context); }, child: Text("Cancel")),
                  SizedBox(width: 10,),
                  ElevatedButton(onPressed: () {
                    Navigator.pop(context);
                    todoBox.deleteAt(index);
                  }, child: Text("Delete"))
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
