import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/shared/usecase.dart';
import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:ch_db_admin/src/Members/domain/repository/member_repo.dart';
import 'package:dartz/dartz.dart';

class AddMember extends UseCase<String, Params<Member, void, void>> {
  final MemberRepository repo;

  AddMember(this.repo);

  @override
  Future<Either<Failure, String>> call(
      Params<Member, void, void> params) async {
    // Convert the Member entity to MemberModel to pass to the data source
    final member = params.data;
    
    // Call the data source to add the member and handle potential failures
    return await repo.addMember(member);
  }
}
