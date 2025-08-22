import 'package:flutter/material.dart';
import '../models/task.dart';
import '../view_models/todo_list_view_model.dart';
import '../theme/glassmorphism_theme.dart';
import '../widgets/animated_background.dart';

class TaskEditView extends StatefulWidget {
  final TodoListViewModel viewModel;
  final String listId;
  final Task? task;

  const TaskEditView({
    Key? key,
    required this.viewModel,
    required this.listId,
    this.task,
  }) : super(key: key);

  @override
  State<TaskEditView> createState() => _TaskEditViewState();
}

class _TaskEditViewState extends State<TaskEditView> {
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    
    final dueDate = widget.task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
    _selectedDate = DateTime(dueDate.year, dueDate.month, dueDate.day);
    _selectedTime = TimeOfDay.fromDateTime(dueDate);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    
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
            isEditing ? 'Edit Task' : 'Create Task',
            style: const TextStyle(
              color: GlassmorphismTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Task Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: GlassmorphismTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _descriptionController,
                        autofocus: !isEditing,
                        maxLines: 3,
                        style: const TextStyle(color: GlassmorphismTheme.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Enter task description...',
                          hintStyle: const TextStyle(color: GlassmorphismTheme.textSecondary),
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
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Due Date & Time',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: GlassmorphismTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GlassCard(
                              onTap: _selectDate,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_rounded,
                                    color: GlassmorphismTheme.primaryPurple,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: GlassmorphismTheme.textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GlassCard(
                              onTap: _selectTime,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_rounded,
                                    color: GlassmorphismTheme.primaryPink,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _selectedTime.format(context),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: GlassmorphismTheme.textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        GlassmorphismTheme.primaryPurple,
                        GlassmorphismTheme.primaryPink,
                      ],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _saveTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Update Task' : 'Create Task',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _saveTask() {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task description')),
      );
      return;
    }

    final dueDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (widget.task != null) {
      // Update existing task
      widget.viewModel.updateTask(
        widget.task!.id,
        description: _descriptionController.text.trim(),
        dueDate: dueDate,
      );
    } else {
      // Create new task
      widget.viewModel.createTask(
        listId: widget.listId,
        description: _descriptionController.text.trim(),
        dueDate: dueDate,
      );
    }

    Navigator.of(context).pop();
  }
}