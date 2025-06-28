import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/shared/usecase.dart';
import 'package:ch_db_admin/src/auth/domain/repository/auth_repo.dart';
import 'package:dartz/dartz.dart';

class ResetPassword extends UseCase<String, Params<String, void, void>> {
  AuthRepo repo;
  ResetPassword(this.repo);
  @override
  Future<Either<Failure, String>> call(Params<String, void, void> params) {
    return repo.resetPassword(params.data);
  }
}
