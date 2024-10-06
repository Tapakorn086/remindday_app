class Group {
  final String id;
  final String name;

  Group({required this.id, required this.name});
}

class GroupService {
  List<Group> _groups = [];

  Future<List<Group>> fetchGroups() async {
    // Implement actual API call here
    await Future.delayed(Duration(seconds: 1)); // Simulating network delay
    return _groups;
  }

  Future<void> createGroup(String name) async {
    // Implement actual API call here
    await Future.delayed(Duration(seconds: 1)); // Simulating network delay
    _groups.add(Group(id: DateTime.now().toString(), name: name));
  }
}