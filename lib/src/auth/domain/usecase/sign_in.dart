// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ch_db_admin/src/auth/data/models/user_login_credentials.dart';
import 'package:ch_db_admin/src/auth/domain/entities/user_credentials.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/shared/usecase.dart';
import 'package:ch_db_admin/src/auth/domain/repository/auth_repo.dart';

class SignIn
    implements UseCase<User?, Params<UserLoginCredentials, void, void>> {
  AuthRepo repo;
  SignIn(this.repo);
  @override
  Future<Either<Failure, User?>> call(
      Params<UserLoginCredentials, void, void> params) async {
    var argument = UserLoginCredentialsModel(
      email: params.data.email,
      password: params.data.password,
    );
    return await repo.signIn(argument);
  }
}
