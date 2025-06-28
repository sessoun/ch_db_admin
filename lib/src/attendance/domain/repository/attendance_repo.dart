import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/src/attendance/domain/entities/attendance.dart';
import 'package:dartz/dartz.dart';

abstract class AttendanceRepository {
  /// Creates a new attendance record.
  Future<Either<Failure, String>> createAttendance(Attendance attendance);

  /// Retrieves all attendance records.
  Future<Either<Failure, List<Attendance>>> fetchAllAttendance();

  /// Retrieves a single attendance record by ID.
  Future<Either<Failure, Attendance?>> fetchAttendanceById(String id);

  /// Updates an attendance record.
  // Future<String> updateAttendance(Attendance attendance);

  /// Deletes an attendance record by ID.
  Future<Either<Failure, String>> removeAttendance(String id);
}
