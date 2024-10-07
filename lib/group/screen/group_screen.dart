// group_screen.dart
import 'package:flutter/material.dart';
import 'package:remindday_app/group/models/group_model.dart';
import '../../group/controller/group_controller.dart';
import '../widgets/group_list_item.dart';

class GroupScreen extends StatefulWidget {
  final int userId;
  const GroupScreen({super.key, required this.userId});

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final GroupController _groupController = GroupController();
  late Future<List<Group>> _groupsFuture;

  @override
  void initState() {
    super.initState();
    _groupsFuture = _groupController.getGroups(widget.userId);
  }

  void _refreshGroups() {
    setState(() {
      _groupsFuture = _groupController.getGroups(widget.userId);
    });
  }

  Future<void> _addGroup() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        String newGroupName = '';
        String newGroupDescription = '';
        return AlertDialog(
          title: const Text('Add New Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Enter group name'),
                onChanged: (value) {
                  newGroupName = value;
                },
              ),
              TextField(
                decoration:
                    const InputDecoration(hintText: 'Enter group description'),
                onChanged: (value) {
                  newGroupDescription = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () => Navigator.of(context).pop({
                'name': newGroupName,
                'description': newGroupDescription,
              }),
            ),
          ],
        );
      },
    );

    if (result != null && result['name']!.isNotEmpty) {
      final referralCode = await _groupController.addGroup(
        result['name']!,
        result['description']!,
        widget.userId,
      );
      _refreshGroups();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Group added with Referral Code: $referralCode')),
      );
    }
  }

  Future<void> _joinGroup() async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String referralCode = '';
        return AlertDialog(
          title: const Text('Join Group'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter group ID'),
            onChanged: (value) {
              referralCode = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Join'),
              onPressed: () => Navigator.of(context).pop(referralCode),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      try {
        await _groupController.joinGroup(result, widget.userId);
        _refreshGroups();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully joined group')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join group: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add),
            onPressed: _addGroup,
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _joinGroup,
          ),
        ],
      ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GroupDetailsScreen(group: snapshot.data![index]),
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

class GroupDetailsScreen extends StatelessWidget {
  final Group group;

  const GroupDetailsScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(group.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Group ID: ${group.id}'),
            Text('Referral Code: ${group.referralCode}'), // แสดง referralCode
          ],
        ),
      ),
    );
  }
}
