import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/shared/usecase.dart';
import 'package:ch_db_admin/src/Members/domain/repository/member_repo.dart';
import 'package:dartz/dartz.dart';

class DeleteMember extends UseCase<String, Params<String, void, void>> {
  final MemberRepository repo;

  DeleteMember(this.repo);

  @override
  Future<Either<Failure, String>> call(Params<String, void, void> params) async {
    

    return await repo.deleteMember(params.data);
  }
}
