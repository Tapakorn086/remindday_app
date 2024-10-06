import 'package:flutter/material.dart';
import '../../group/service/group_service.dart';

class GroupListItem extends StatelessWidget {
  final Group group;
  final VoidCallback? onTap;

  const GroupListItem({
    Key? key,
    required this.group,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            group.name.substring(0, 1).toUpperCase(),
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          group.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Group ID: ${group.id}'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap ?? () {
          // Default onTap behavior if not provided
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tapped on ${group.name}')),
          );
        },
      ),
    );
  }
}