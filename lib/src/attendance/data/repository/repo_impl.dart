import 'dart:io';

import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/src/attendance/data/data_source/remote_db.dart';
import 'package:ch_db_admin/src/attendance/data/models/attendance.dart';
import 'package:ch_db_admin/src/attendance/domain/entities/attendance.dart';
import 'package:ch_db_admin/src/attendance/domain/repository/attendance_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceDB _attendanceDB;

  AttendanceRepositoryImpl(this._attendanceDB);

  @override
  Future<Either<Failure,String>> createAttendance(
      Attendance attendance) async {
    final attendanceModel = AttendanceModel(
      members: attendance.members,
      createdAt: attendance.createdAt,
      event: attendance.event,
    );
    try {
      final result = await _attendanceDB.createAttendance(attendanceModel);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(Failure(e.message ?? 'Error adding member',
          code: e.code)); // Firebase failure
    } on SocketException catch (_) {
      return Left(Failure('No internet connection')); // Network failure
    } catch (e) {
      return Left(Failure('Unknown error: $e')); // Generic failure
    }
  }

  @override
  Future<Either<Failure,List<AttendanceModel>>> fetchAllAttendance() async {
   try{   final result = await _attendanceDB.getAllAttendance();
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(Failure(e.message ?? 'Error getting attendance',
          code: e.code)); // Firebase failure
    } on SocketException catch (_) {
      return Left(Failure('No internet connection')); // Network failure
    } catch (e) {
      return Left(Failure('Unknown error: $e')); // Generic failure
    }  }

  @override
  Future<Either<Failure,AttendanceModel?>> fetchAttendanceById(
      String id) async {
    try {
      final result = await _attendanceDB.getAttendanceById(id);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(Failure(e.message ?? 'Error getting attendance',
          code: e.code)); // Firebase failure
    } on SocketException catch (_) {
      return Left(Failure('No internet connection')); // Network failure
    } catch (e) {
      return Left(Failure('Unknown error: $e')); // Generic failure
    }
  }

  // @override
  // Future<String> updateAttendance(Attendance attendance) async {
  //   final attendanceModel = AttendanceModel(members: attendance.members, createdAt: attendance.createdAt, event:attendance. event);
  //   return await _attendanceDB.;
  // }

  @override
  Future<Either<Failure,String>> removeAttendance(String id) async {
    try{  final result = await _attendanceDB.deleteAttendance(id);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(Failure(e.message ?? 'Error adding member',
          code: e.code)); // Firebase failure
    } on SocketException catch (_) {
      return Left(Failure('No internet connection')); // Network failure
    } catch (e) {
      return Left(Failure('Unknown error: $e')); // Generic failure
    }  }
}
