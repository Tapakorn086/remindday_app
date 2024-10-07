import 'package:remindday_app/RemindDayList/services/gettodo_service.dart';
import 'package:remindday_app/RemindDayList/models/gettodo.dart';

class TodoController {
  final ApiService apiService;

  TodoController(this.apiService);

  Future<List<Todo>> getTodos() {
    return apiService.fetchTodos();
  }
}
