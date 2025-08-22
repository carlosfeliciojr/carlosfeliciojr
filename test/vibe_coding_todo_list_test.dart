import 'package:flutter_test/flutter_test.dart';
import 'package:vibe_coding_todo_list/vibe_coding_todo_list.dart';

void main() {
  group('TodoList and Task Models', () {
    test('TodoList creation', () {
      final list = TodoList(
        id: '1',
        title: 'Test List',
        createdAt: DateTime.now(),
      );
      
      expect(list.id, '1');
      expect(list.title, 'Test List');
      expect(list.createdAt, isA<DateTime>());
    });

    test('Task creation and isOverdue property', () {
      final now = DateTime.now();
      final pastDate = now.subtract(const Duration(days: 1));
      final futureDate = now.add(const Duration(days: 1));
      
      // Task that is overdue
      final overdueTask = Task(
        id: '1',
        listId: 'list1',
        description: 'Overdue task',
        createdAt: now,
        dueDate: pastDate,
        isCompleted: false,
      );
      
      expect(overdueTask.isOverdue, true);
      
      // Task that is not overdue (future date)
      final futureTask = Task(
        id: '2',
        listId: 'list1',
        description: 'Future task',
        createdAt: now,
        dueDate: futureDate,
        isCompleted: false,
      );
      
      expect(futureTask.isOverdue, false);
      
      // Task that is past due but completed (not overdue)
      final completedTask = Task(
        id: '3',
        listId: 'list1',
        description: 'Completed task',
        createdAt: now,
        dueDate: pastDate,
        isCompleted: true,
      );
      
      expect(completedTask.isOverdue, false);
    });
  });

  group('TodoRepository', () {
    late TodoRepository repository;

    setUp(() {
      repository = TodoRepository();
    });

    test('create and retrieve lists', () {
      final list = repository.createList('1', 'Test List');
      
      expect(list.id, '1');
      expect(list.title, 'Test List');
      
      final retrievedList = repository.getListById('1');
      expect(retrievedList, equals(list));
      
      final allLists = repository.getAllLists();
      expect(allLists.length, 1);
      expect(allLists.first, equals(list));
    });

    test('create and retrieve tasks', () {
      final list = repository.createList('1', 'Test List');
      final dueDate = DateTime.now().add(const Duration(days: 1));
      
      final task = repository.createTask(
        id: '1',
        listId: list.id,
        description: 'Test task',
        dueDate: dueDate,
      );
      
      expect(task.id, '1');
      expect(task.listId, list.id);
      expect(task.description, 'Test task');
      expect(task.isCompleted, false);
      
      final tasksForList = repository.getTasksForList(list.id);
      expect(tasksForList.length, 1);
      expect(tasksForList.first, equals(task));
    });

    test('delete list removes associated tasks', () {
      final list = repository.createList('1', 'Test List');
      repository.createTask(
        id: '1',
        listId: list.id,
        description: 'Task 1',
        dueDate: DateTime.now().add(const Duration(days: 1)),
      );
      repository.createTask(
        id: '2',
        listId: list.id,
        description: 'Task 2',
        dueDate: DateTime.now().add(const Duration(days: 2)),
      );
      
      expect(repository.getAllTasks().length, 2);
      
      final deleted = repository.deleteList(list.id);
      expect(deleted, true);
      expect(repository.getAllTasks().length, 0);
      expect(repository.getAllLists().length, 0);
    });

    test('update task properties', () {
      final list = repository.createList('1', 'Test List');
      final task = repository.createTask(
        id: '1',
        listId: list.id,
        description: 'Original description',
        dueDate: DateTime.now().add(const Duration(days: 1)),
      );
      
      final updatedTask = repository.updateTask(
        task.id,
        description: 'Updated description',
        isCompleted: true,
      );
      
      expect(updatedTask!.description, 'Updated description');
      expect(updatedTask.isCompleted, true);
    });

    test('get overdue tasks', () {
      final list = repository.createList('1', 'Test List');
      final now = DateTime.now();
      
      // Overdue task
      repository.createTask(
        id: '1',
        listId: list.id,
        description: 'Overdue task',
        dueDate: now.subtract(const Duration(days: 1)),
      );
      
      // Future task
      repository.createTask(
        id: '2',
        listId: list.id,
        description: 'Future task',
        dueDate: now.add(const Duration(days: 1)),
      );
      
      // Overdue but completed task
      final overdueCompleted = repository.createTask(
        id: '3',
        listId: list.id,
        description: 'Overdue completed task',
        dueDate: now.subtract(const Duration(days: 2)),
      );
      repository.updateTask(overdueCompleted.id, isCompleted: true);
      
      final overdueTasks = repository.getOverdueTasks();
      expect(overdueTasks.length, 1);
      expect(overdueTasks.first.description, 'Overdue task');
    });
  });

  group('TodoListViewModel with Timer', () {
    test('creates view model with timer', () {
      final repository = TodoRepository();
      final viewModel = TodoListViewModel(repository);
      
      expect(viewModel.lists, isEmpty);
      expect(viewModel.tasks, isEmpty);
      
      viewModel.dispose();
    });

    test('force overdue check works', () {
      final repository = TodoRepository();
      final viewModel = TodoListViewModel(repository);
      
      final list = repository.createList('1', 'Test List');
      repository.createTask(
        id: '1',
        listId: list.id,
        description: 'Soon to be overdue',
        dueDate: DateTime.now().subtract(const Duration(seconds: 1)),
      );
      
      viewModel.loadData();
      viewModel.forceOverdueCheck();
      
      final overdueTasks = viewModel.getOverdueTasks();
      expect(overdueTasks.length, 1);
      expect(overdueTasks.first.description, 'Soon to be overdue');
      
      viewModel.dispose();
    });
  });
}
