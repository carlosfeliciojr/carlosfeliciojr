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
    super.key,
    required this.viewModel,
    required this.listId,
    this.task,
  });

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
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: GlassmorphismTheme.textPrimary,
            ),
            onPressed: () => Navigator.of(context).pop(),
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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initialDate = _selectedDate.isBefore(today) ? today : _selectedDate;
    
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: DialogThemeData(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
            ),
            colorScheme: Theme.of(context).colorScheme.copyWith(
              surface: GlassmorphismTheme.darkBackground,
              onSurface: GlassmorphismTheme.textPrimary,
              primary: GlassmorphismTheme.primaryPurple,
              onPrimary: Colors.white,
              surfaceTint: Colors.transparent,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: GlassmorphismTheme.darkBackground,
              surfaceTintColor: Colors.transparent,
              headerBackgroundColor: GlassmorphismTheme.darkBackground,
              headerForegroundColor: GlassmorphismTheme.textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              weekdayStyle: const TextStyle(
                color: GlassmorphismTheme.textSecondary,
              ),
              dayStyle: const TextStyle(
                color: GlassmorphismTheme.textPrimary,
              ),
              yearStyle: const TextStyle(
                color: GlassmorphismTheme.textPrimary,
              ),
            ),
          ),
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  maxWidth: 400,
                  maxHeight: 500,
                ),
                decoration: BoxDecoration(
                  color: GlassmorphismTheme.darkBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: child!,
                ),
              ),
            ),
          ),
        );
      },
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: DialogThemeData(
              backgroundColor: GlassmorphismTheme.darkBackground,
            ),
            colorScheme: Theme.of(context).colorScheme.copyWith(
              surface: GlassmorphismTheme.darkBackground,
              onSurface: GlassmorphismTheme.textPrimary,
              primary: GlassmorphismTheme.primaryPurple,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: GlassmorphismTheme.darkBackground,
              dialBackgroundColor: Colors.white.withValues(alpha: 0.1),
              dialHandColor: GlassmorphismTheme.primaryPink,
              dialTextColor: GlassmorphismTheme.textPrimary,
              hourMinuteTextColor: GlassmorphismTheme.textPrimary,
              dayPeriodTextColor: GlassmorphismTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
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