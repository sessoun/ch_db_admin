// lib/data/models/member_model.dart

import 'package:ch_db_admin/src/Members/domain/entities/member.dart';

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
  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      fullName: json['fullName'],
      location: json['location'],
      contact: json['contact'],
      marriageStatus: json['marriageStatus'],
      spouseName: json['spouseName'],
      children:
          json['children'] != null ? List<String>.from(json['children']) : null,
      relativeContact: json['relativeContact'],
      additionalImage: json['additionalImageUrl'],
      profilePic: json['profilePicUrl'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
    );
  }

  // Method for converting a MemberModel to JSON
  Map<String, dynamic> toJson() {
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
      'dateOfBirth': dateOfBirth.toIso8601String(),
    };
  }
}
