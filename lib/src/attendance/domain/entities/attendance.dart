import 'package:ch_db_admin/src/Members/domain/entities/member.dart';

class Attendance {
  final List<Member> members;
  final DateTime createdAt;
  final String event;
  String? id;

  Attendance({
    this.id,
    required this.members,
    required this.createdAt,
    required this.event,
  });
}
