// lib/src/Members/domain/repositories/member_repository.dart

import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:dartz/dartz.dart';
import 'package:ch_db_admin/shared/failure.dart';

abstract class MemberRepository {
  Future<Either<Failure, String>> addMember(Member member);
  Future<Either<Failure, Member?>> getMemberById(String memberId);
  Future<Either<Failure, List<Member>>> getAllMembers();
  Future<Either<Failure, String>> updateMember(String memberId, Member member);
  Future<Either<Failure, String>> deleteMember(String memberId);
  Future<Either<Failure, List<Member>>> getMembersByName(String name);
}
