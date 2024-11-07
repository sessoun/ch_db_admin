import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/shared/usecase.dart';
import 'package:ch_db_admin/src/Members/data/models/member_model.dart';
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
    final memberModel = MemberModel(
        fullName: member.fullName,
        location: member.location,
        contact: member.contact,
        marriageStatus: member.marriageStatus,
        spouseName: member.spouseName,
        children: member.children,
        relativeContact: member.relativeContact,
        additionalImage: member.additionalImage,
        profilePic: member.profilePic,
        dateOfBirth: member.dateOfBirth,
        role: member.role,
        groupAffiliate: member.groupAffiliate);

    // Call the data source to add the member and handle potential failures
    return await repo.addMember(member);
  }
}
