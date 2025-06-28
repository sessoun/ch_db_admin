import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/shared/usecase.dart';
import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:ch_db_admin/src/Members/domain/repository/member_repo.dart';
import 'package:dartz/dartz.dart';

class UpdateMember extends UseCase<String, Params<String, Member, void>> {
  final MemberRepository repo;

  UpdateMember(this.repo);

  @override
  Future<Either<Failure, String>> call(
      Params<String, Member, void> params) async {
    return await repo.updateMember(params.data, params.data2!);
  }
}
