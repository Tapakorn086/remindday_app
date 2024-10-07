// group_controller.dart
import 'package:remindday_app/group/models/group_model.dart';
import '../service/group_service.dart';

class GroupController {
  final GroupService _groupService = GroupService();

  Future<List<Group>> getGroups(int userId) async {
    return await _groupService.getGroupsByUserId(userId);
  }

  Future<String> addGroup(String name, String description, int ownerId) async {
    return await _groupService.addGroup(name, description, ownerId);
  }
}
