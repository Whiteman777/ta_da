import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ta_da/models/task.dart';
import 'package:ta_da/models/to_do.dart';
import 'package:ta_da/widgets/todo_entry_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  final taskController = TextEditingController();
  final todoHeads = <ToDoHead>[].obs;
  final tasks = <Task>[].obs;
  final taskBox = Hive.box<Task>('tasks');
  final toDoBox = Hive.lazyBox<ToDo>('todos');
  final toDoHeadBox = Hive.box<ToDoHead>("todos_head");
  final todoId = Rxn<int>();

  @override
  void initState() {
    loadHeads();
    loadTasks();
    super.initState();
  }

  void loadHeads() {
    todoHeads.assignAll(toDoHeadBox.values);
    if (todoId.value == null && todoHeads.isNotEmpty) {
      todoId.value = todoHeads.first.id;
    }
  }

  void loadTasks() {
    tasks.assignAll(taskBox.values);
  }

  @override
  void dispose() {
    searchController.dispose();
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ta-Da",
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showModalBottomSheet(
            context: context,
            builder: (ctx) => TodoEntryForm(),
          );
          if (result is ToDoHead) {
            todoHeads.add(result);
          }
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.text,
                controller: searchController,
                decoration: InputDecoration(
                  label: Text("Search"),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 56,
                child: Obx(() {
                  final selectedId = todoId.value;
                  if (todoHeads.isEmpty) {
                    return Center(child: Text("add a todo"));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: todoHeads.length,
                    itemBuilder: (_, index) => Padding(
                      padding: const EdgeInsetsGeometry.all(3),
                      child: FilterChip(
                        label: Text(todoHeads[index].name),
                        selected: todoHeads[index].id == selectedId,
                        onSelected: (bool selected) {
                          todoId.value = todoHeads[index].id;
                        },
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: taskController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Add a Task"),
                  suffix: IconButton.filledTonal(
                    onPressed: () {
                      final result = Task(
                        id: tasks.length + 1,
                        title: taskController.text,
                        todoId: todoId.value!,
                      );
                      taskController.clear();
                      taskBox.put(tasks.length + 1, result);
                      tasks.add(result);
                    },
                    icon: Icon(Icons.add),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Obx(() {
                  final filteredTasks = tasks
                      .where((id) => id.todoId == todoId.value)
                      .toList();
                  return ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (_, index) => ListTile(
                      leading: Checkbox(value: false, onChanged: (d) {}),
                      title: Text(filteredTasks[index].title),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
