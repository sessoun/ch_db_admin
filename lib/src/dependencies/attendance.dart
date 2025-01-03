import 'package:ch_db_admin/src/attendance/data/data_source/remote_db.dart';
import 'package:ch_db_admin/src/attendance/data/repository/repo_impl.dart';
import 'package:ch_db_admin/src/attendance/domain/repository/attendance_repo.dart';
import 'package:ch_db_admin/src/attendance/domain/usecase/create_attendance.dart';
import 'package:ch_db_admin/src/attendance/domain/usecase/get_all_attendance.dart';
import 'package:ch_db_admin/src/attendance/domain/usecase/get_attendance_by_id.dart';
import 'package:ch_db_admin/src/attendance/presentation/controller/attendance_controller.dart';
import 'package:ch_db_admin/src/dependencies/auth.dart';

void initAttendanceDep() {
  locator.registerLazySingleton<AttendanceDB>(
    () => AttendanceDB(),
  );
  locator.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(locator.get<AttendanceDB>()),
  );
  locator.registerLazySingleton<CreateAttendance>(
    () => CreateAttendance(locator.get<AttendanceRepository>()),
  );
  locator.registerLazySingleton<FetchAllAttendance>(
    () => FetchAllAttendance(locator.get<AttendanceRepository>()),
  );
  locator.registerLazySingleton<FetchAttendanceById>(
    () => FetchAttendanceById(locator.get<AttendanceRepository>()),
  );
  locator.registerLazySingleton<AttendanceController>(
    () => AttendanceController(
        createAttendanceUseCase: locator.get<CreateAttendance>(),
        fetchAllAttendanceUseCase: locator.get<FetchAllAttendance>(),
        fetchAttendanceByIdUseCase: locator.get<FetchAttendanceById>()),
  );
}
