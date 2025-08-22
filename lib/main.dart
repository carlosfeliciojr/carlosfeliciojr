import 'package:flutter/material.dart';
import 'repositories/todo_repository.dart';
import 'view_models/todo_list_view_model.dart';
import 'views/todo_lists_view.dart';
import 'services/notification_service.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
    
    return MaterialApp(
      title: 'Vibe Coding Todo List',
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TodoAppHome(scaffoldMessengerKey: scaffoldMessengerKey),
    );
  }
}

class TodoAppHome extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  
  const TodoAppHome({
    super.key,
    required this.scaffoldMessengerKey,
  });

  @override
  State<TodoAppHome> createState() => _TodoAppHomeState();
}

class _TodoAppHomeState extends State<TodoAppHome> {
  late final TodoRepository _repository;
  late final TodoListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    
    // Initialize notification service
    NotificationService.initialize(widget.scaffoldMessengerKey);
    
    _repository = TodoRepository();
    _viewModel = TodoListViewModel(_repository);
    
    // Create some sample data for demonstration
    _createSampleData();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
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

    // Test task that will become overdue in 1 minute (for testing)
    _repository.createTask(
      id: '8',
      listId: workList.id,
      description: 'Test task - will become overdue in 1 minute',
      dueDate: now.add(const Duration(minutes: 1)),
    );

    // Notify the view model to update
    _viewModel.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return TodoListsView(viewModel: _viewModel);
  }
}

