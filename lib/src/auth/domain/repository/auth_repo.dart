import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/src/auth/data/models/user_login_credentials.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepo {
  Future<Either<Failure, User?>> signIn(UserLoginCredentialsModel data);
  Future<Either<Failure, String>> logOut();
  Future<Either<Failure, String>> resetPassword(String email);
}
