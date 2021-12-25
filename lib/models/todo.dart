
import 'package:hive/hive.dart';
part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String description;

  Todo({required this.name, required this.description});
}