class TodoList {
  final String id;
  final String title;
  final DateTime createdAt;

  TodoList({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  TodoList copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
  }) {
    return TodoList(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TodoList && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TodoList(id: $id, title: $title, createdAt: $createdAt)';
}