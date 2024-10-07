import '../models/todolist_model.dart';
import '../services/todolist_service.dart';

class RemindDayListController {
  final TodoService _todoService = TodoService();
  DateTime _selectedDate = DateTime.now();
  late List<DateTime> _weekDays;

  RemindDayListController() {
    _weekDays = _generateWeekDays(_selectedDate);
  }

  DateTime get selectedDate => _selectedDate;
  List<DateTime> get weekDays => _weekDays;

  set selectedDate(DateTime date) {
    _selectedDate = date;
    _weekDays = _generateWeekDays(date);
  }

  List<DateTime> _generateWeekDays(DateTime centerDate) {
    return List.generate(7, (index) => centerDate.subtract(Duration(days: 3 - index)));
  }

  Future<List<Todo>> fetchTodos() async {
    try {
      return await _todoService.fetchTodos();
    } catch (e) {
      print('Error fetching todos: $e');
      return [];
    }
  }
}