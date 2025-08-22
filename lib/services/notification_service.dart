import 'package:flutter/material.dart';
import '../models/task.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static GlobalKey<ScaffoldMessengerState>? _scaffoldMessengerKey;
  static final List<OverdueNotification> _pendingNotifications = [];
  static bool _isShowingNotification = false;

  static void initialize(GlobalKey<ScaffoldMessengerState> key) {
    _scaffoldMessengerKey = key;
  }

  void showOverdueTaskNotification(Task task) {
    final notification = OverdueNotification(
      task: task,
      timestamp: DateTime.now(),
    );

    _pendingNotifications.add(notification);
    
    if (!_isShowingNotification) {
      _showNextNotification();
    }
  }

  static void _showNextNotification() {
    if (_pendingNotifications.isEmpty || _scaffoldMessengerKey?.currentState == null) {
      _isShowingNotification = false;
      return;
    }

    _isShowingNotification = true;
    final notification = _pendingNotifications.removeAt(0);

    _scaffoldMessengerKey!.currentState!.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.warning,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tarefa Vencida!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    notification.task.description,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'Ver',
          textColor: Colors.white,
          onPressed: () {
            // Aqui poderia navegar para a tarefa específica
          },
        ),
      ),
    ).closed.then((_) {
      // Quando a notificação atual terminar, mostrar a próxima
      Future.delayed(const Duration(milliseconds: 500), () {
        _isShowingNotification = false;
        if (_pendingNotifications.isNotEmpty) {
          _showNextNotification();
        }
      });
    });
  }

  void clearPendingNotifications() {
    _pendingNotifications.clear();
  }

  int getPendingNotificationCount() {
    return _pendingNotifications.length;
  }
}

class OverdueNotification {
  final Task task;
  final DateTime timestamp;

  OverdueNotification({
    required this.task,
    required this.timestamp,
  });
}