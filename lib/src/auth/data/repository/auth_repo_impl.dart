import 'dart:io';

import 'package:ch_db_admin/shared/exceptions/app_exception.dart';
import 'package:ch_db_admin/shared/exceptions/firebase_exception.dart'
    as custom;
import 'package:ch_db_admin/shared/exceptions/network_exception.dart';
import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/src/auth/data/data_source/remote_s.dart';
import 'package:ch_db_admin/src/auth/data/models/user_login_credentials.dart';
import 'package:ch_db_admin/src/auth/domain/repository/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../shared/utils/custom_print.dart';

class AuthRepoImpl implements AuthRepo {
  final LoginRemoteS auth;

  AuthRepoImpl(this.auth);
  @override
  Future<Either<Failure, User?>> signIn(UserLoginCredentialsModel data) async {
    try {
      final result = await auth.signIn(data);
      return Right(result);
    } on custom.FirebaseAuthException catch (e) {
      miPrint(e);
      if (e.code == 'user-not-found') {
        return Left(Failure(
          'No user found for that email.',
        ));
      } else if (e.code == 'invalid-credential') {
        return Left(Failure('The supplied credential is incorrect.'));
      } else if (e.code == 'too-many-requests') {
        return Left(Failure('Too many requests. Try again later'));
      } else if (e.code == 'network-request-failed') {
        return Left(Failure(
            'A network error has occurred. Check your internet settings'));
      } else {
        miPrint(e.code);
        return Left(Failure(e.message));
      }
    } on NetworkException catch (e) {
      if (e.message.contains('network-request-failed')) {
        return Left(
            Failure('A network error. Please check your network settings.'));
      } else {
        return Left(Failure('Internet connection error'));
      }
    } on AppException catch (e) {
      miPrint(e);
      return Left(Failure('An unknown error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> logOut() async {
    try {
      final result = await auth.logOut();
      return Right(result);
    } on FirebaseAuthException {
      throw custom.FirebaseAuthException(
        'Something went wrong while logging out',
      );
    } on SocketException {
      throw NetworkException(
          'No internet connection. Please check your network settings.');
    } on Exception catch (e) {
      throw AppException('An unknown error occurred: ${e.toString()}');
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword(String email) async {
    try {
      final result = await auth.resetPassword(email);
      return Right(result);
    } on FirebaseAuthException {
      throw custom.FirebaseAuthException(
        'Something went wrong while sending password reset email',
      );
    } on SocketException {
      throw NetworkException(
          'No internet connection. Please check your network settings.');
    } on Exception catch (e) {
      throw AppException('An unknown error occurred: ${e.toString()}');
    }
  }
}
