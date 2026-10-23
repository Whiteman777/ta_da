import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ta_da/models/to_do.dart';
import 'package:dartx/dartx.dart';

class TodoEntryForm extends StatefulWidget {
  const TodoEntryForm({super.key});

  @override
  State<TodoEntryForm> createState() => _TodoEntryFormState();
}

class _TodoEntryFormState extends State<TodoEntryForm> {
  final idController = TextEditingController();
  final nameController = TextEditingController();

  final toDoHeadBox = Hive.box<ToDoHead>("todos_head");
  final toDoBox = Hive.lazyBox<ToDo>('todos');

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          children: [
            Text(
              "Add a Todo",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: idController,
              decoration: InputDecoration(
                label: Text("id"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                label: Text("name"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("cancel"),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final head = ToDoHead(
                      id: idController.text.toInt(),
                      name: nameController.text,
                    );

                    final toDo = ToDo(
                      id: idController.text.toInt(),
                      name: nameController.text,
                    );

                    await toDoHeadBox.put(head.id, head);
                    await toDoBox.put(toDo.id, toDo);
                    Get.back(result: head);
                  },
                  child: Text("save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
