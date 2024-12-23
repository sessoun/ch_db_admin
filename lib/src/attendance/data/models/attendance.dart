import 'package:ch_db_admin/src/attendance/domain/entities/attendance.dart';


class AttendanceModel extends Attendance {
  AttendanceModel({
    required super.members,
    required super.createdAt,
    required super.event,
  });

  // Example of method to convert AttendanceModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'members': members,
      'dcreatedAtate': createdAt.toIso8601String(),
            'event': event,
    };
  }

  // Example of method to create AttendanceModel from JSON
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      members: json['members'],
      createdAt: DateTime.parse(json['createdAt']),
      event: json['event'],
    );
  }
}
