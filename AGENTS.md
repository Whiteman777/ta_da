# Context — Hive Todo App (learning project)

Carried-over context from a previous opencode session. The user is learning local databases in Flutter; this project is the **NoSQL (classic Hive 2.2.3)** learning exercise. A separate Floor (SQL) exercise exists separately (expense tracker idea, not started).

## Decisions made
- Project folder: this one (`ta_da`)
- Package: **classic `hive: ^2.2.3`** (NOT hive_ce — user explicitly chose it to match tutorials)
- No state management package — Hive's own `ValueListenableBuilder` + `box.listenable()` reactivity
- UI is deliberately plain; the point is database implementation, not looks

## Plan

### Packages
```bash
flutter pub add hive path_provider
flutter pub add --dev hive_generator build_runner
```

### Structure
```
lib/
  main.dart               # init + runApp
  models/todo.dart        # @HiveType model
  models/todo.g.dart      # generated adapter (build_runner)
  screens/todo_page.dart  # whole UI in one screen
```

### Data model
`Todo` with `@HiveType(typeId: 0)`: `id`, `title`, `isDone`, `createdAt` — each `@HiveField(1..4)`.

### Two boxes, two flavors
- `Box<Todo>('todos')` — typed box, auto-increment keys via `box.add()`
- Plain dynamic `Box('settings')` — primitive key-value, e.g. `put('showCompleted', true)`

### Features (one screen)
1. TextField + ADD button → writes `Todo` to the todos box
2. Checkbox per row → re-`put` the object with toggled `isDone` (teaching point: mutating a stored object does nothing until saved back)
3. Delete via `box.delete(box.keyAt(index))`
4. ⚙ settings dialog → toggles `showCompleted` bool; done rows hidden when off
5. List rebuilt with `ValueListenableBuilder(box.listenable())` — no setState

### Init in main()
```dart
WidgetsFlutterBinding.ensureInitialized();
Hive.init(); // or use path_provider dir
Hive.registerAdapter(TodoAdapter());
await Hive.openBox<Todo>('todos');
await Hive.openBox('settings');
runApp(...);
```

### Concepts being taught
- TypeAdapter generation (`dart run build_runner build`)
- Typed vs dynamic boxes, auto-increment keys
- CRUD: add / put / get / delete / keyAt
- Hive-native reactivity instead of state management
- Persistence proof: hot-restart and data survives

### Stretch (only when core works)
- Add a `Priority` enum field to `Todo` to see enum adapters

## Verify
- `dart run build_runner build` clean
- `flutter run` → add / toggle / delete todo → hot-restart/check hot restart → state intact
