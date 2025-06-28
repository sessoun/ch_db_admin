import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/shared/usecase.dart';
import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:ch_db_admin/src/Members/domain/repository/member_repo.dart';
import 'package:dartz/dartz.dart';

class GetMemberById extends UseCase<Member?, Params<String, void, void>> {
  final MemberRepository repo;

  GetMemberById(this.repo);

  @override
  Future<Either<Failure, Member?>> call(
      Params<String, void, void> params) async {
    return await repo.getMemberById(params.data);
  }
}
