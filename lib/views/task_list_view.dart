import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/todo_list.dart';
import '../models/task.dart';
import '../view_models/todo_list_view_model.dart';
import '../theme/glassmorphism_theme.dart';
import '../widgets/animated_background.dart';
import 'task_edit_view.dart';

class TaskListView extends StatelessWidget {
  final TodoListViewModel viewModel;
  final TodoList todoList;

  const TaskListView({
    Key? key,
    required this.viewModel,
    required this.todoList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GlassCard(
            padding: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(12),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: GlassmorphismTheme.textPrimary,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: Text(
            todoList.title,
            style: const TextStyle(
              color: GlassmorphismTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              final tasks = viewModel.getTasksForList(todoList.id);
              
              if (tasks.isEmpty) {
                return Center(
                  child: GlassCard(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.task_alt_rounded,
                          size: 64,
                          color: GlassmorphismTheme.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No tasks yet',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: GlassmorphismTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Add your first task to get started!',
                          style: TextStyle(
                            fontSize: 16,
                            color: GlassmorphismTheme.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildTaskTile(context, task),
                    );
                  },
                ),
              );
            },
          ),
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                GlassmorphismTheme.primaryPink,
                GlassmorphismTheme.primaryPurple,
              ],
            ),
          ),
          child: FloatingActionButton(
            onPressed: () => _navigateToCreateTask(context),
            tooltip: 'Add Task',
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add_rounded, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskTile(BuildContext context, Task task) {
    Color? cardColor;
    if (task.isOverdue && !task.isCompleted) {
      cardColor = Colors.red;
    } else if (task.isCompleted) {
      cardColor = GlassmorphismTheme.primaryBlue;
    }

    return GlassCard(
      color: cardColor,
      child: Row(
        children: [
          // Checkbox
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: task.isCompleted 
                  ? GlassmorphismTheme.primaryPurple
                  : Colors.white.withValues(alpha: 0.5),
                width: 2,
              ),
              gradient: task.isCompleted 
                ? LinearGradient(
                    colors: [
                      GlassmorphismTheme.primaryPurple,
                      GlassmorphismTheme.primaryPink,
                    ],
                  )
                : null,
            ),
            child: task.isCompleted
              ? const Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: Colors.white,
                )
              : null,
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: task.isCompleted 
                      ? GlassmorphismTheme.textSecondary
                      : GlassmorphismTheme.textPrimary,
                    decoration: task.isCompleted 
                      ? TextDecoration.lineThrough 
                      : null,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: task.isOverdue && !task.isCompleted
                        ? Colors.red.shade300
                        : GlassmorphismTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDateTime(task.dueDate),
                      style: TextStyle(
                        fontSize: 13,
                        color: task.isOverdue && !task.isCompleted
                          ? Colors.red.shade300
                          : GlassmorphismTheme.textSecondary,
                        fontWeight: task.isOverdue && !task.isCompleted
                          ? FontWeight.w600
                          : FontWeight.normal,
                      ),
                    ),
                    if (task.isOverdue && !task.isCompleted) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'OVERDUE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => viewModel.toggleTaskComplete(task.id),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    task.isCompleted 
                      ? Icons.undo_rounded
                      : Icons.check_rounded,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GlassCard(
                padding: const EdgeInsets.all(6),
                borderRadius: BorderRadius.circular(8),
                child: PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: GlassmorphismTheme.textSecondary,
                    size: 16,
                  ),
                  color: GlassmorphismTheme.darkBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.edit_rounded,
                            color: GlassmorphismTheme.primaryBlue,
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Edit',
                            style: TextStyle(color: GlassmorphismTheme.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_rounded,
                            color: Colors.red.shade400,
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Delete',
                            style: TextStyle(color: GlassmorphismTheme.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      _navigateToEditTask(context, task);
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context, task);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _navigateToCreateTask(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskEditView(
          viewModel: viewModel,
          listId: todoList.id,
        ),
      ),
    );
  }

  void _navigateToEditTask(BuildContext context, Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskEditView(
          viewModel: viewModel,
          listId: todoList.id,
          task: task,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: Colors.red.shade400,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Delete Task',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: GlassmorphismTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Are you sure you want to delete "${task.description}"?',
                  style: const TextStyle(
                    fontSize: 16,
                    color: GlassmorphismTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: GlassmorphismTheme.textSecondary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.red.shade600,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          viewModel.deleteTask(task.id);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}