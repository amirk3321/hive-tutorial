import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'models/todo.dart';

class TodoFormPage extends StatelessWidget {
  const TodoFormPage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    var name;
    var desc;

    final _formKey = GlobalKey<FormState>();

    void addTodo(Todo todo) {
      final todoBox = Hive.box('todos');
      todoBox.add(todo);
    }
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Name",
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      name = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "field cannot be empty*";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Description",
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      desc = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "field cannot be empty*";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState?.save();
              final newTodo = Todo(name: name, description: desc);
              print("name : ${newTodo.name}, desc : ${newTodo.description}");
              addTodo(newTodo);
            } else {
              return null;
            }
          }, child: Text("Add"))
        ],
      ),
    );
  }
}
