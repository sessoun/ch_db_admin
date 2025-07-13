import 'package:dartz/dartz.dart';
import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/src/Members/data/models/member_model.dart';
import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:developer';

import '../../../../shared/utils/custom_print.dart';
import '../../domain/repository/member_repo.dart';
import '../data_source/remote_db.dart';

class MemberRepositoryImpl implements MemberRepository {
  final MembersRemoteDb remoteDb;

  MemberRepositoryImpl(this.remoteDb);

  // Convert MemberModel to Member
  Member _convertMemberModelToMember(MemberModel memberModel) {
    miPrint('mId: ${memberModel.id}');
    return Member(
        id: memberModel.id,
        fullName: memberModel.fullName,
        location: memberModel.location,
        contact: memberModel.contact,
        marriageStatus: memberModel.marriageStatus,
        spouseName: memberModel.spouseName,
        children: memberModel.children,
        status: memberModel.status,
        relativeContact: memberModel.relativeContact,
        profilePic: memberModel.profilePic,
        dateOfBirth: memberModel.dateOfBirth,
        role: memberModel.role,
        groupAffiliate: memberModel.groupAffiliate);
  }

  @override
  Future<Either<Failure, String>> addMember(Member member) async {
    miPrint(member.role);
    try {
      final memberModel = MemberModel(
        fullName: member.fullName,
        location: member.location,
        contact: member.contact,
        marriageStatus: member.marriageStatus,
        spouseName: member.spouseName,
        children: member.children,
        relativeContact: member.relativeContact,
        profilePic: member.profilePic,
        groupAffiliate: member.groupAffiliate,
        dateOfBirth: member.dateOfBirth,
        status: member.status,
        role: member.role,
      );
      final result = await remoteDb.addMember(memberModel);
      return Right(result); // Success case
    } on FirebaseException catch (e) {
      return Left(Failure(e.message ?? 'Error adding member',
          code: e.code)); // Firebase failure
    } on SocketException catch (e) {
      log('here: $e');
      return Left(Failure('No internet connection')); // Network failure
    } catch (e) {
      return Left(Failure('Unknown error: $e')); // Generic failure
    }
  }

  @override
  Future<Either<Failure, Member?>> getMemberById(String memberId) async {
    try {
      final memberModel = await remoteDb.getMemberById(memberId);
      if (memberModel == null) {
        return Left(Failure('Member with ID $memberId not found'));
      }
      return Right(_convertMemberModelToMember(
          memberModel)); // Convert MemberModel to Member
    } on FirebaseException catch (e) {
      return Left(Failure(e.message ?? 'Error fetching member', code: e.code));
    } on SocketException catch (e) {
      log('here: $e');
      return Left(Failure('No internet connection'));
    } catch (e) {
      return Left(Failure('Unknown error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Member>>> getAllMembers() async {
    try {
      final members = await remoteDb.getAllMembers();
      // Convert each MemberModel to Member before returning
      return Right(members.map(_convertMemberModelToMember).toList());
    } on FirebaseException catch (e) {
      return Left(Failure(e.message ?? 'Error fetching members', code: e.code));
    } on SocketException catch (e) {
      log('here: $e');
      return Left(Failure('No internet connection'));
    } catch (e) {
      return Left(Failure('Unknown error: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> updateMember(
      String memberId, Member member) async {
    try {
      final memberModel = MemberModel(
        fullName: member.fullName,
        location: member.location,
        contact: member.contact,
        marriageStatus: member.marriageStatus,
        spouseName: member.spouseName,
        status: member.status,
        children: member.children,
        relativeContact: member.relativeContact,
        profilePic: member.profilePic,
        groupAffiliate: member.groupAffiliate,
        dateOfBirth: member.dateOfBirth,
        role: member.role,
      );
      final result = await remoteDb.updateMember(memberId, memberModel);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(Failure(e.message ?? 'Error updating member', code: e.code));
    } on SocketException catch (e) {
      log('here: $e');
      return Left(Failure('No internet connection'));
    } catch (e) {
      return Left(Failure('Unknown error: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> deleteMember(String memberId) async {
    try {
      final result = await remoteDb.deleteMember(memberId);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(Failure(e.message ?? 'Error deleting member', code: e.code));
    } on SocketException catch (e) {
      log('here: $e');
      return Left(Failure('No internet connection'));
    } catch (e) {
      return Left(Failure('Unknown error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Member>>> getMembersByName(String name) async {
    try {
      final members = await remoteDb.getMembersByName(name);
      // Convert each MemberModel to Member before returning
      return Right(members.map(_convertMemberModelToMember).toList());
    } on FirebaseException catch (e) {
      return Left(
          Failure(e.message ?? 'Error fetching members by name', code: e.code));
    } on SocketException catch (e) {
      log('here: $e');
      return Left(Failure('No internet connection'));
    } catch (e) {
      return Left(Failure('Unknown error: $e'));
    }
  }
}
