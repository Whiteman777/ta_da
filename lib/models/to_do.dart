import 'package:hive_flutter/hive_flutter.dart';
import 'package:ta_da/models/task.dart';

part 'to_do.g.dart';

@HiveType(typeId: 1)
class ToDo {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final DateTime updatedAt;

  ToDo({
    required this.id,
    required this.name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
}

@HiveType(typeId: 2)
class ToDoHead {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  const ToDoHead({
    required this.id,
    required this.name,
  });
}
