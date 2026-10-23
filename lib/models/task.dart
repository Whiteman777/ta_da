import 'package:hive_flutter/hive_flutter.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool isCompleted = false;

  @HiveField(3)
  final int todoId;

  const Task({required this.id, required this.title, required this.todoId});
}
