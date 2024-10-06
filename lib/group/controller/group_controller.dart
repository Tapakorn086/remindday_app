import '../../group/service/group_service.dart';

class GroupController {
  final GroupService _groupService = GroupService();

  Future<List<Group>> getGroups() async {
    return await _groupService.fetchGroups();
  }

  Future<void> addGroup(String name) async {
    await _groupService.createGroup(name);
  }
}