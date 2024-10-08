class Todo {
  final int? id;
  final String? title;
  final String? description;
  final String? status;
  final String? idDevice;
  final String? startDate;
  final String? startTime;
  final int? notifyMinutesBefore;
  final String? importance;
  final String? type;
  final int? groupId;
  final int? userId;

  Todo({
    this.id,
    this.title,
    this.description,
    this.status,
    this.idDevice,
    this.startDate,
    this.startTime,
    this.notifyMinutesBefore,
    this.importance,
    this.type,
    this.groupId,
    this.userId,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      idDevice: json['idDevice'],
      startDate: json['startDate'],
      startTime: json['startTime'],
      notifyMinutesBefore: json['notifyMinutesBefore'],
      importance: json['importance'],
      type: json['type'],
      groupId: json['groupId'],
      userId: json['userId'],
    );
  }
}