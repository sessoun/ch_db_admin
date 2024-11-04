// lib/data/models/member_model.dart

import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberModel extends Member {
  MemberModel({
    required super.fullName,
    required super.location,
    required super.contact,
    required super.marriageStatus,
    super.spouseName,
    super.children,
    super.relativeContact,
    super.additionalImage,
    super.profilePic,
    required super.dateOfBirth,
  });

  // Factory method for creating a MemberModel from JSON
  factory MemberModel.fromFirebase(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return  MemberModel(
      fullName: data['fullName'] ?? '',
      location: data['location'] ?? '',
      contact: data['contact'] ?? '',
      marriageStatus: data['marriageStatus'] ?? '',
      spouseName: data['spouseName'],
      children: data['children'] != null ? List<String>.from(data['children']) : null,
      relativeContact: data['relativeContact'],
      additionalImage: data['additionalImageUrl'],
      profilePic: data['profilePicUrl'],
      dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
    );
  }

  // Method for converting a MemberModel to JSON
  Map<String, dynamic> toFirebase() {
    return {
      'fullName': fullName,
      'location': location,
      'contact': contact,
      'marriageStatus': marriageStatus,
      'spouseName': spouseName,
      'children': children,
      'relativeContact': relativeContact,
      'additionalImageUrl': additionalImage,
      'profilePicUrl': profilePic,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
    };
  }
}
