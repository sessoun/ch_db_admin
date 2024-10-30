import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/shared/usecase.dart';
import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:ch_db_admin/src/Members/domain/repository/member_repo.dart';
import 'package:dartz/dartz.dart';

class GetMembersByName extends UseCase<List<Member>, Params<String, void, void>> {
  final MemberRepository repo;

  GetMembersByName(this.repo);

  @override
  Future<Either<Failure, List<Member>>> call(Params<String, void, void> params) async {
    
    return await repo.getMembersByName(params.data);
  }
}
