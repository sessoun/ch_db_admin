// Example widget to display a status indicator
import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:flutter/material.dart';

Widget memberStatusIndicator(MemberStatus status) {
  Color color;
  String label;

  switch (status) {
    case MemberStatus.newMember:
      color = Colors.green;
      label = 'New';
      break;
    case MemberStatus.active:
      color = Colors.blue;
      label = 'Active';
      break;
    case MemberStatus.inactive:
      color = Colors.red;
      label = 'Inactive';
      break;
    case MemberStatus.visitor:
      color = Colors.orange;
      label = 'Visitor';
      break;
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircleAvatar(
        radius: 6,
        backgroundColor: color,
      ),
      const SizedBox(width: 6),
      Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    ],
  );
}
