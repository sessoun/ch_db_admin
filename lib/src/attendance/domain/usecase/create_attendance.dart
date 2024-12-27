import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/shared/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:ch_db_admin/src/attendance/domain/entities/attendance.dart';
import 'package:ch_db_admin/src/attendance/domain/repository/attendance_repo.dart';

class CreateAttendance extends UseCase<String, Params<Attendance, void, void>> {
  final AttendanceRepository repository;

  CreateAttendance(this.repository);

  @override
  Future<Either<Failure, String>> call(Params<Attendance, void, void> params) {
    return repository.createAttendance(params.data);
  }
}
