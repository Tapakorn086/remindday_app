import 'package:flutter/material.dart';
import 'package:remindday_app/group/models/group_model.dart';

class GroupListItem extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const GroupListItem({super.key, required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(group.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Referral Code: ${group.referralCode}'),
          Text('Owner ID: ${group.ownerId}'),
          // เพิ่มข้อมูลอื่นๆ ตามต้องการ
        ],
      ),
      onTap: onTap,
    );
  }
}
