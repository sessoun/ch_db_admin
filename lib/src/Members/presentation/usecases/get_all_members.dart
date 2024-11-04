// lib/src/Members/domain/usecases/get_all_members.dart

import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:ch_db_admin/src/Members/domain/repository/member_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/shared/usecase.dart';

class GetAllMembers extends UseCase<List<Member>, NoParams> {
  final MemberRepository repository;

  GetAllMembers(this.repository);

  @override
  Future<Either<Failure, List<Member>>> call(NoParams params) {
    return repository.getAllMembers();
  }
}
