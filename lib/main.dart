import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ta_da/models/to_do.dart';
import 'package:ta_da/pages/home_page.dart';

import 'models/task.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(ToDoAdapter());
  Hive.registerAdapter(ToDoHeadAdapter());

  await Hive.openBox<Task>('tasks');
  await Hive.openBox<ToDoHead>('todos_head');
  await Hive.openLazyBox<ToDo>('todos');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  runApp(
    GetMaterialApp(
      home: HomePage(),
    ),
  );
}
