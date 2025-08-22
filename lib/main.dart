import 'package:flutter/material.dart';
import 'repositories/todo_repository.dart';
import 'view_models/todo_list_view_model.dart';
import 'views/todo_lists_view.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibe Coding Todo List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoAppHome(),
    );
  }
}

class TodoAppHome extends StatefulWidget {
  const TodoAppHome({super.key});

  @override
  State<TodoAppHome> createState() => _TodoAppHomeState();
}

class _TodoAppHomeState extends State<TodoAppHome> {
  late final TodoRepository _repository;
  late final TodoListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _repository = TodoRepository();
    _viewModel = TodoListViewModel(_repository);
    
    // Create some sample data for demonstration
    _createSampleData();
  }

  void _createSampleData() {
    // Create sample lists
    final workList = _repository.createList('1', 'Work Tasks');
    final personalList = _repository.createList('2', 'Personal Tasks');
    final shoppingList = _repository.createList('3', 'Shopping List');

    // Create sample tasks with different due dates and completion status
    final now = DateTime.now();
    
    // Work tasks
    _repository.createTask(
      id: '1',
      listId: workList.id,
      description: 'Complete project proposal',
      dueDate: now.add(const Duration(days: 2)),
    );
    
    _repository.createTask(
      id: '2',
      listId: workList.id,
      description: 'Review team performance',
      dueDate: now.add(const Duration(days: 1)),
    );
    
    // Overdue work task
    _repository.createTask(
      id: '3',
      listId: workList.id,
      description: 'Submit quarterly report',
      dueDate: now.subtract(const Duration(days: 1)),
    );

    // Personal tasks
    final personalTask1 = _repository.createTask(
      id: '4',
      listId: personalList.id,
      description: 'Call dentist for appointment',
      dueDate: now.add(const Duration(days: 3)),
    );
    
    // Mark this task as completed
    _repository.updateTask(personalTask1.id, isCompleted: true);
    
    _repository.createTask(
      id: '5',
      listId: personalList.id,
      description: 'Plan weekend trip',
      dueDate: now.add(const Duration(days: 5)),
    );

    // Shopping tasks
    _repository.createTask(
      id: '6',
      listId: shoppingList.id,
      description: 'Buy groceries',
      dueDate: now.add(const Duration(hours: 6)),
    );
    
    _repository.createTask(
      id: '7',
      listId: shoppingList.id,
      description: 'Pick up dry cleaning',
      dueDate: now.add(const Duration(days: 1, hours: 2)),
    );

    // Notify the view model to update
    _viewModel.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return TodoListsView(viewModel: _viewModel);
  }
}

// Example usage demonstration
void demonstrateUsage() {
  print('=== Todo List Application Demo ===\n');
  
  // Create repository and view model
  final repository = TodoRepository();
  final viewModel = TodoListViewModel(repository);
  
  // Create lists
  print('Creating todo lists...');
  viewModel.createList('Work Projects');
  viewModel.createList('Personal Goals');
  
  final lists = viewModel.lists;
  final workListId = lists[0].id;
  final personalListId = lists[1].id;
  
  print('Created lists:');
  for (final list in lists) {
    print('  - ${list.title} (ID: ${list.id})');
  }
  print('');
  
  // Create tasks
  print('Adding tasks...');
  final now = DateTime.now();
  
  viewModel.createTask(
    listId: workListId,
    description: 'Complete Flutter app',
    dueDate: now.add(const Duration(days: 3)),
  );
  
  viewModel.createTask(
    listId: workListId,
    description: 'Write documentation',
    dueDate: now.add(const Duration(days: 1)),
  );
  
  // Add an overdue task
  viewModel.createTask(
    listId: workListId,
    description: 'Submit status report',
    dueDate: now.subtract(const Duration(days: 1)),
  );
  
  viewModel.createTask(
    listId: personalListId,
    description: 'Exercise for 30 minutes',
    dueDate: now.add(const Duration(hours: 2)),
  );
  
  // Display all tasks
  print('All tasks:');
  for (final task in viewModel.tasks) {
    print('  - ${task.description}');
    print('    Due: ${task.dueDate}');
    print('    Completed: ${task.isCompleted}');
    print('    Overdue: ${task.isOverdue}');
    print('');
  }
  
  // Show overdue tasks
  final overdueTasks = viewModel.getOverdueTasks();
  print('Overdue tasks (${overdueTasks.length}):');
  for (final task in overdueTasks) {
    print('  - ${task.description} (Due: ${task.dueDate})');
  }
  print('');
  
  // Mark a task as complete
  final firstTask = viewModel.tasks.first;
  print('Marking task as complete: ${firstTask.description}');
  viewModel.toggleTaskComplete(firstTask.id);
  print('Task completed: ${viewModel.tasks.first.isCompleted}');
  print('');
  
  // Update task description
  print('Updating task description...');
  viewModel.updateTask(
    firstTask.id,
    description: 'Complete Flutter app with tests',
  );
  print('Updated task: ${viewModel.tasks.first.description}');
  print('');
  
  // Delete a task
  final taskToDelete = viewModel.tasks.last;
  print('Deleting task: ${taskToDelete.description}');
  viewModel.deleteTask(taskToDelete.id);
  print('Remaining tasks: ${viewModel.tasks.length}');
  print('');
  
  // Show list statistics
  for (final list in viewModel.lists) {
    final taskCount = viewModel.getTaskCountForList(list.id);
    final completedCount = viewModel.getCompletedTaskCountForList(list.id);
    final overdueCount = viewModel.getOverdueTasksForList(list.id).length;
    
    print('${list.title}:');
    print('  Total tasks: $taskCount');
    print('  Completed: $completedCount');
    print('  Overdue: $overdueCount');
    print('');
  }
  
  print('=== Demo completed ===');
}