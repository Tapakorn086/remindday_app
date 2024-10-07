import 'package:remindday_app/todo/services/note_service.dart';
import 'package:remindday_app/todo/models/note_model.dart'; // Ensure this path is correct

class NoteController {
  final NoteService _noteService = NoteService();

  Future<void> addNote({
    required String title,
    required String description,
    required String type,
    required String importance,
    required String startTime,
    required String startDate,
    required int notifyMinutesBefore,
    required String status,
  }) async {
    Note newNote = Note(
      title: title,
      description: description,
      type: type,
      importance: importance,
      startTime: startTime,
      startDate: startDate,
      notifyMinutesBefore: notifyMinutesBefore,
      status: status,
    );

    try {
      await _noteService.addNote(newNote);
    } catch (e) {
      // Handle error (e.g., show a message to the user)
      print('Error adding note: $e');
    }
  }
}
