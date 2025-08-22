import 'package:flutter/foundation.dart';
import '../models/todo_list.dart';
import '../models/task.dart';
import '../repositories/todo_repository.dart';

class TodoListViewModel extends ChangeNotifier {
  final TodoRepository _repository;
  List<TodoList> _lists = [];
  List<Task> _tasks = [];

  TodoListViewModel(this._repository) {
    _loadData();
  }

  List<TodoList> get lists => _lists;
  List<Task> get tasks => _tasks;

  void _loadData() {
    _lists = _repository.getAllLists();
    _tasks = _repository.getAllTasks();
    notifyListeners();
  }

  void loadData() {
    _loadData();
  }

  // List operations
  
  void createList(String title) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _repository.createList(id, title);
    _loadData();
  }

  void deleteList(String listId) {
    _repository.deleteList(listId);
    _loadData();
  }

  // Task operations
  
  void createTask({
    required String listId,
    required String description,
    required DateTime dueDate,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _repository.createTask(
      id: id,
      listId: listId,
      description: description,
      dueDate: dueDate,
    );
    _loadData();
  }

  void updateTask(String taskId, {
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    _repository.updateTask(
      taskId,
      description: description,
      dueDate: dueDate,
      isCompleted: isCompleted,
    );
    _loadData();
  }

  void toggleTaskComplete(String taskId) {
    final task = _repository.getTaskById(taskId);
    if (task != null) {
      _repository.updateTask(taskId, isCompleted: !task.isCompleted);
      _loadData();
    }
  }

  void deleteTask(String taskId) {
    _repository.deleteTask(taskId);
    _loadData();
  }

  // Utility methods
  
  List<Task> getTasksForList(String listId) {
    return _tasks.where((task) => task.listId == listId).toList();
  }

  List<Task> getOverdueTasks() {
    return _tasks.where((task) => task.isOverdue).toList();
  }

  List<Task> getOverdueTasksForList(String listId) {
    return _tasks
        .where((task) => task.listId == listId && task.isOverdue)
        .toList();
  }

  int getTaskCountForList(String listId) {
    return getTasksForList(listId).length;
  }

  int getCompletedTaskCountForList(String listId) {
    return getTasksForList(listId)
        .where((task) => task.isCompleted)
        .length;
  }
}