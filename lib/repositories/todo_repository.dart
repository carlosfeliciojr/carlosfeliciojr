import '../models/todo_list.dart';
import '../models/task.dart';

class TodoRepository {
  final Map<String, TodoList> _lists = {};
  final Map<String, Task> _tasks = {};

  // List CRUD operations
  
  TodoList createList(String id, String title) {
    final list = TodoList(
      id: id,
      title: title,
      createdAt: DateTime.now(),
    );
    _lists[id] = list;
    return list;
  }

  List<TodoList> getAllLists() {
    return _lists.values.toList();
  }

  TodoList? getListById(String id) {
    return _lists[id];
  }

  bool deleteList(String id) {
    if (!_lists.containsKey(id)) return false;
    
    // Delete all tasks associated with this list
    _tasks.removeWhere((taskId, task) => task.listId == id);
    
    // Delete the list
    _lists.remove(id);
    return true;
  }

  // Task CRUD operations
  
  Task createTask({
    required String id,
    required String listId,
    required String description,
    required DateTime dueDate,
  }) {
    final task = Task(
      id: id,
      listId: listId,
      description: description,
      createdAt: DateTime.now(),
      dueDate: dueDate,
    );
    _tasks[id] = task;
    return task;
  }

  List<Task> getTasksForList(String listId) {
    return _tasks.values.where((task) => task.listId == listId).toList();
  }

  List<Task> getAllTasks() {
    return _tasks.values.toList();
  }

  Task? getTaskById(String id) {
    return _tasks[id];
  }

  Task? updateTask(String id, {
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    final task = _tasks[id];
    if (task == null) return null;

    final updatedTask = task.copyWith(
      description: description,
      dueDate: dueDate,
      isCompleted: isCompleted,
    );
    
    _tasks[id] = updatedTask;
    return updatedTask;
  }

  Task? markTaskComplete(String id) {
    return updateTask(id, isCompleted: true);
  }

  bool deleteTask(String id) {
    return _tasks.remove(id) != null;
  }

  // Utility methods
  
  List<Task> getOverdueTasks() {
    return _tasks.values.where((task) => task.isOverdue).toList();
  }

  List<Task> getOverdueTasksForList(String listId) {
    return _tasks.values
        .where((task) => task.listId == listId && task.isOverdue)
        .toList();
  }

  void clear() {
    _lists.clear();
    _tasks.clear();
  }
}