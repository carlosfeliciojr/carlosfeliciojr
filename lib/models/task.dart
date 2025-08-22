class Task {
  final String id;
  final String listId;
  final String description;
  final DateTime createdAt;
  final DateTime dueDate;
  final bool isCompleted;

  Task({
    required this.id,
    required this.listId,
    required this.description,
    required this.createdAt,
    required this.dueDate,
    this.isCompleted = false,
  });

  bool get isOverdue {
    return DateTime.now().isAfter(dueDate) && !isCompleted;
  }

  Task copyWith({
    String? id,
    String? listId,
    String? description,
    DateTime? createdAt,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Task(id: $id, listId: $listId, description: $description, '
        'createdAt: $createdAt, dueDate: $dueDate, isCompleted: $isCompleted, '
        'isOverdue: $isOverdue)';
  }
}