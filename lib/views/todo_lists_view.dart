import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/todo_list.dart';
import '../view_models/todo_list_view_model.dart';
import '../theme/glassmorphism_theme.dart';
import '../widgets/animated_background.dart';
import 'task_list_view.dart';

class TodoListsView extends StatelessWidget {
  final TodoListViewModel viewModel;

  const TodoListsView({
    Key? key,
    required this.viewModel,
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
          title: const Text(
            'Todo Lists',
            style: TextStyle(
              color: GlassmorphismTheme.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            ListenableBuilder(
              listenable: viewModel,
              builder: (context, child) {
                final overdueCount = viewModel.getOverdueTasks().length;
                if (overdueCount > 0) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.warning_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$overdueCount vencida${overdueCount > 1 ? 's' : ''}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
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
        body: SafeArea(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              if (viewModel.lists.isEmpty) {
                return Center(
                  child: GlassCard(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.checklist_rounded,
                          size: 64,
                          color: GlassmorphismTheme.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No lists yet',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: GlassmorphismTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Create your first list to get started!',
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
                  itemCount: viewModel.lists.length,
                  itemBuilder: (context, index) {
                    final todoList = viewModel.lists[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildListTile(context, todoList),
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
            onPressed: () => _showCreateListDialog(context),
            tooltip: 'Add List',
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add_rounded, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, TodoList todoList) {
    final taskCount = viewModel.getTaskCountForList(todoList.id);
    final completedCount = viewModel.getCompletedTaskCountForList(todoList.id);
    final overdueCount = viewModel.getOverdueTasksForList(todoList.id).length;

    return GlassCard(
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
      child: Row(
        children: [
          // List icon with gradient background
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  GlassmorphismTheme.primaryPurple.withValues(alpha: 0.8),
                  GlassmorphismTheme.primaryPink.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: const Icon(
              Icons.checklist_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todoList.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: GlassmorphismTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: GlassmorphismTheme.primaryBlue.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$completedCount/$taskCount completed',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (overdueCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.warning_rounded,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$overdueCount overdue',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Menu button
          GlassCard(
            padding: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(12),
            child: PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert_rounded,
                color: GlassmorphismTheme.textSecondary,
                size: 20,
              ),
              color: GlassmorphismTheme.darkBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_rounded,
                        color: Colors.red.shade400,
                        size: 20,
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
                if (value == 'delete') {
                  _showDeleteConfirmation(context, todoList);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateListDialog(BuildContext context) {
    final controller = TextEditingController();
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
                const Text(
                  'Create New List',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: GlassmorphismTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  autofocus: true,
                  style: const TextStyle(color: GlassmorphismTheme.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'List Title',
                    labelStyle: const TextStyle(color: GlassmorphismTheme.textSecondary),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: GlassmorphismTheme.primaryPurple,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
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
                        gradient: LinearGradient(
                          colors: [
                            GlassmorphismTheme.primaryPurple,
                            GlassmorphismTheme.primaryPink,
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.text.trim().isNotEmpty) {
                            viewModel.createList(controller.text.trim());
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child: const Text('Create'),
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

  void _showDeleteConfirmation(BuildContext context, TodoList todoList) {
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
                      'Delete List',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: GlassmorphismTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Are you sure you want to delete "${todoList.title}"?\n\nThis will also delete all tasks in this list.',
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
                          viewModel.deleteList(todoList.id);
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