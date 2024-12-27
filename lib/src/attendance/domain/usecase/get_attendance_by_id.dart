import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/shared/usecase.dart';
import 'package:ch_db_admin/src/attendance/domain/entities/attendance.dart';
import 'package:dartz/dartz.dart';
import 'package:ch_db_admin/src/attendance/domain/repository/attendance_repo.dart';

class FetchAttendanceById extends UseCase<Attendance?, Params<String, void, void>> {
  final AttendanceRepository repository;

  FetchAttendanceById(this.repository);

  @override
  Future<Either<Failure, Attendance?>> call(Params<String, void, void> params) {
    return repository.fetchAttendanceById(params.data);
  }
}
