class Note {
  final String title;
  final String description;
  final String importance;
  final int notifyMinutesBefore; // Keep as int
  final String startDate; // Keep as String
  final String startTime; // Keep as String
  final String status;
  final String type;

  Note({
    required this.title,
    required this.description,
    required this.importance,
    required this.notifyMinutesBefore,
    required this.startDate,
    required this.startTime,
    required this.status,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'importance': importance,
      'notify_minutes_before': notifyMinutesBefore, // Update to match the JSON key
      'start_date': startDate, // Update to match the JSON key
      'start_time': startTime, // Update to match the JSON key
      'status': status,
      'type': type,
    };
  }
}
