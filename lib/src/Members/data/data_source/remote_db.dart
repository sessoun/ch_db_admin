import 'dart:developer';
import 'dart:io';
import 'package:ch_db_admin/shared/exceptions/database_exception.dart';
import 'package:ch_db_admin/src/Members/data/models/member_model.dart';
import 'package:ch_db_admin/src/dependencies/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/exceptions/app_exception.dart';
import '../../../../shared/exceptions/network_exception.dart';

class MembersRemoteDb {

  final prefs = locator.get<SharedPreferences>();
  final db = FirebaseFirestore.instance
      .collection('organisations')
      .doc(locator.get<SharedPreferences>().getString('org_id'))
      .collection('members');
      

  

  // Create a member in the Firestore database
  Future<String> addMember(MemberModel data) async {
    try {
      final docRef = db.doc();
      await docRef.set(data.toFirebase());
      return 'Member details added with id ${docRef.id}';
    } on FirebaseException catch (e) {
      throw DatabaseException(e.message ?? 'Error adding member\'s details',
          code: e.code);
    } on SocketException catch (e) {
      log('here: $e');
      throw NetworkException(e.message);
    } on Exception catch (e) {
      throw AppException(e.toString());
    }
  }

  // Read a member by ID from Firestore
  Future<MemberModel?> getMemberById(String memberId) async {
    try {
      final doc = await db.doc(memberId).get();
      if (doc.exists) {
        return MemberModel.fromFirebase(doc);
      } else {
        throw AppException('Member with ID $memberId not found');
      }
    } on FirebaseException catch (e) {
      throw DatabaseException(e.message ?? 'Error fetching member details',
          code: e.code);
    } on SocketException catch (e) {
      log('here: $e');
      throw NetworkException(e.message);
    } on Exception catch (e) {
      throw AppException(e.toString());
    }
  }

  // Update a member's details in Firestore
  Future<String> updateMember(String memberId, MemberModel data) async {
    try {
      await db.doc(memberId).update(data.toFirebase());
      return 'Member details updated successfully';
    } on FirebaseException catch (e) {
      throw DatabaseException(e.message ?? 'Error updating member\'s details',
          code: e.code);
    } on SocketException catch (e) {
      log('here: $e');
      throw NetworkException(e.message);
    } on Exception catch (e) {
      throw AppException(e.toString());
    }
  }

  // Delete a member from Firestore
  Future<String> deleteMember(String memberId) async {
    try {
      await db.doc(memberId).delete();
      return 'Member deleted successfully';
    } on FirebaseException catch (e) {
      throw DatabaseException(e.message ?? 'Error deleting member',
          code: e.code);
    } on SocketException catch (e) {
      log('here: $e');
      throw NetworkException(e.message);
    } on Exception catch (e) {
      throw AppException(e.toString());
    }
  }

  // Read all members from Firestore
  Future<List<MemberModel>> getAllMembers() async {
    try {
      final snapshot = await db.get();
      return snapshot.docs.map((doc) => MemberModel.fromFirebase(doc)).toList();
    } on FirebaseException catch (e) {
      throw DatabaseException(e.message ?? 'Error fetching members list',
          code: e.code);
    } on SocketException catch (e) {
      log('here: $e');
      throw NetworkException(e.message);
    } on Exception catch (e) {
      throw AppException(e.toString());
    }
  }

  // Filter members by name (or any field)
  Future<List<MemberModel>> getMembersByName(String name) async {
    try {
      final snapshot = await db
          .where('fullName', isGreaterThanOrEqualTo: name)
          .where('fullName', isLessThanOrEqualTo: '$name\uf8ff')
          .get();

      return snapshot.docs.map((doc) => MemberModel.fromFirebase(doc)).toList();
    } on FirebaseException catch (e) {
      throw DatabaseException(e.message ?? 'Error fetching members by name',
          code: e.code);
    } on SocketException catch (e) {
      log('here: $e');
      throw NetworkException(e.message);
    } on Exception catch (e) {
      throw AppException(e.toString());
    }
  }
}
