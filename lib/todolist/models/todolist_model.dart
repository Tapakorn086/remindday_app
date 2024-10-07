class Todo {
  final int id;
  final String title;
  final String description;
  final String type;
  final String importance;
  final String status;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.importance,
    required this.status,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      importance: json['importance'],
      status: json['status'],
    );
  }
}