import 'package:ch_db_admin/src/attendance/domain/entities/attendance.dart';


class AttendanceModel extends Attendance {
  AttendanceModel({
    required super.memberId,
    required super.date,
    required super.isPresent,
    super.notes,
  });

  // Example of method to convert AttendanceModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'date': date.toIso8601String(),
      'isPresent': isPresent,
      'notes': notes,
    };
  }

  // Example of method to create AttendanceModel from JSON
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      memberId: json['memberId'],
      date: DateTime.parse(json['date']),
      isPresent: json['isPresent'],
      notes: json['notes'],
    );
  }
}
