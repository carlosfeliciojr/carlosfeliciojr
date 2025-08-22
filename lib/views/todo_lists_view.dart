import 'package:flutter/material.dart';
import '../models/todo_list.dart';
import '../view_models/todo_list_view_model.dart';
import 'task_list_view.dart';

class TodoListsView extends StatelessWidget {
  final TodoListViewModel viewModel;

  const TodoListsView({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Lists'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              final overdueCount = viewModel.getOverdueTasks().length;
              if (overdueCount > 0) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.warning,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$overdueCount vencida${overdueCount > 1 ? 's' : ''}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          if (viewModel.lists.isEmpty) {
            return const Center(
              child: Text(
                'No lists yet. Create your first list!',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: viewModel.lists.length,
            itemBuilder: (context, index) {
              final todoList = viewModel.lists[index];
              return _buildListTile(context, todoList);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateListDialog(context),
        tooltip: 'Add List',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, TodoList todoList) {
    final taskCount = viewModel.getTaskCountForList(todoList.id);
    final completedCount = viewModel.getCompletedTaskCountForList(todoList.id);
    final overdueCount = viewModel.getOverdueTasksForList(todoList.id).length;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          todoList.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$completedCount/$taskCount tasks completed'),
            if (overdueCount > 0)
              Text(
                '$overdueCount overdue tasks',
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'delete',
              child: const Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'delete') {
              _showDeleteConfirmation(context, todoList);
            }
          },
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskListView(
                viewModel: viewModel,
                todoList: todoList,
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCreateListDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New List'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'List Title',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                viewModel.createList(controller.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, TodoList todoList) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete List'),
        content: Text(
          'Are you sure you want to delete "${todoList.title}"? '
          'This will also delete all tasks in this list.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.deleteList(todoList.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}