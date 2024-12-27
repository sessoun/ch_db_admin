import 'package:ch_db_admin/shared/usecase.dart';
import 'package:ch_db_admin/src/attendance/domain/usecase/create_attendance.dart';
import 'package:ch_db_admin/src/attendance/domain/usecase/get_all_attendance.dart';
import 'package:ch_db_admin/src/attendance/domain/usecase/get_attendance_by_id.dart';
import 'package:flutter/foundation.dart';
import 'package:ch_db_admin/src/attendance/domain/entities/attendance.dart';

class AttendanceController extends ChangeNotifier {
  final CreateAttendance createAttendanceUseCase;
  final FetchAllAttendance fetchAllAttendanceUseCase;
  final FetchAttendanceById fetchAttendanceByIdUseCase;
  // final RemoveAttendance removeAttendanceUseCase;

  // State variables
  List<Attendance> _attendanceList = [];
  Attendance? _attendance;
  String? _message;
  bool _isLoading = false;

  AttendanceController({
    required this.createAttendanceUseCase,
    required this.fetchAllAttendanceUseCase,
    required this.fetchAttendanceByIdUseCase,
    // required this.removeAttendanceUseCase,
  });

  // Getters for state variables
  List<Attendance> get attendanceList => _attendanceList;
  Attendance? get attendance => _attendance;
  String? get message => _message;
  bool get isLoading => _isLoading;

  /// Create a new attendance record
  Future<void> createAttendance(Attendance attendance) async {
    _setLoading(true);
    final result = await createAttendanceUseCase(Params(attendance));
    result.fold(
      (failure) {
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _message = data;
        notifyListeners();
      },
    );
    _setLoading(false);
  }

  /// Fetch all attendance records
  Future<void> fetchAllAttendance() async {
    _setLoading(true);
    final result = await fetchAllAttendanceUseCase(NoParams());
    result.fold(
      (failure) {
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _attendanceList = data;
        notifyListeners();
      },
    );
    _setLoading(false);
  }

  /// Fetch a single attendance record by ID
  Future<void> fetchAttendanceById(String id) async {
    _setLoading(true);
    final result = await fetchAttendanceByIdUseCase(Params(id));
    result.fold(
      (failure) {
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _attendance = data;
        notifyListeners();
      },
    );
    _setLoading(false);
  }

  /// Remove an attendance record by ID
  // Future<void> removeAttendance(String id) async {
  //   _setLoading(true);
  //   final result = await removeAttendanceUseCase(Params(id));
  //   result.fold(
  //     (failure) {
  //       _message = failure.message;
  //       notifyListeners();
  //     },
  //     (data) {
  //       _message = data;
  //       notifyListeners();
  //     },
  //   );
  //   _setLoading(false);
  // }

  // Private helper method to manage loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
