import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/shared/usecase.dart';
import 'package:ch_db_admin/src/attendance/domain/entities/attendance.dart';
import 'package:dartz/dartz.dart';
import 'package:ch_db_admin/src/attendance/domain/repository/attendance_repo.dart';

class FetchAllAttendance extends UseCase<List<Attendance>, NoParams> {
  final AttendanceRepository repository;

  FetchAllAttendance(this.repository);

  @override
  Future<Either<Failure, List<Attendance>>> call(NoParams params) {
    return repository.fetchAllAttendance();
  }
}
