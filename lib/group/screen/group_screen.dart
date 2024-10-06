import 'package:flutter/material.dart';
import '../../group/controller/group_controller.dart';
import '../widgets/group_list_item.dart';
import '../../group/service/group_service.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final GroupController _groupController = GroupController();
  late Future<List<Group>> _groupsFuture;

  @override
  void initState() {
    super.initState();
    _groupsFuture = _groupController.getGroups();
  }

  void _refreshGroups() {
    setState(() {
      _groupsFuture = _groupController.getGroups();
    });
  }

  Future<void> _addGroup() async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String newGroupName = '';
        return AlertDialog(
          title: const Text('Add New Group'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter group name'),
            onChanged: (value) {
              newGroupName = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () => Navigator.of(context).pop(newGroupName),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      await _groupController.addGroup(result);
      _refreshGroups();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Groups')),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshGroups();
        },
        child: FutureBuilder<List<Group>>(
          future: _groupsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No groups found'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return GroupListItem(
                    group: snapshot.data![index],
                    onTap: () {
                      // Navigate to group details screen
                      // You'll need to implement this screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupDetailsScreen(group: snapshot.data![index]),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGroup,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Placeholder for GroupDetailsScreen
class GroupDetailsScreen extends StatelessWidget {
  final Group group;

  const GroupDetailsScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(group.name)),
      body: Center(child: Text('Group Details: ${group.id}')),
    );
  }
}