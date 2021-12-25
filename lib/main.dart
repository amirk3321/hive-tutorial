
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_tutorial/todo_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'models/todo.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(TodoAdapter());
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Hive.openBox('todos'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return TodoPage();
            }
          } else {
            return Scaffold();
          }
        },
    ),
    );
  }
}
