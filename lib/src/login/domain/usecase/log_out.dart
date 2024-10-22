// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/shared/usecase.dart';
import 'package:ch_db_admin/src/login/domain/repository/auth_repo.dart';

class SignOut extends UseCase<String, NoParams> {
  AuthRepo repo;
  SignOut(this.repo);
  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repo.logOut();
  }
}
