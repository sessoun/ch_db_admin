import 'package:ch_db_admin/src/Members/data/models/member_model.dart';
import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:ch_db_admin/src/attendance/domain/entities/attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/utils/custom_print.dart';

class AttendanceModel extends Attendance {
  AttendanceModel({
    super.id,
    required super.members,
    required super.createdAt,
    required super.event,
  });

  Map<String, dynamic> toFirebase() {
    return {
      'members': members.map(
        (member) {
          final memberModel = MemberModel(
            id: member.id,
            fullName: member.fullName,
            location: member.location,
            contact: member.contact,
            status: member.status,
            marriageStatus: member.marriageStatus,
            dateOfBirth: member.dateOfBirth,
            additionalImage: member.additionalImage,
            children: member.children,
            groupAffiliate: member.groupAffiliate,
            profilePic: member.profilePic,
            relativeContact: member.relativeContact,
            role: member.role,
            spouseName: member.spouseName,
          );
          return memberModel.toFirebase();
        },
      ).toList(),
      'createdAt': Timestamp.now(),
      'event': event,
    };
  }

  // Example of method to create AttendanceModel from JSON
  factory AttendanceModel.fromFirestore(DocumentSnapshot doc) {
    final id = doc.id;
    final data = doc.data() as Map<String, dynamic>;

    // Debugging: Log the data for inspection
    miPrint("Raw data: $data");

    // Handle members safely
    final members = (data['members'] as List<dynamic>?)
            ?.map((memberData) {
              return Member(
                id: memberData['id'],
                fullName: memberData['fullName'],
                location: memberData['location'],
                contact: memberData['contact'],
                status: MemberStatus.values.firstWhere(
                  (e) => e.name == (memberData['status'] ?? 'newMember'),
                  orElse: () => MemberStatus.newMember,
                ),
                marriageStatus: memberData['marriageStatus'],
                dateOfBirth: (memberData['dateOfBirth'] as Timestamp).toDate(),
                additionalImage: memberData['additionalImage'],
                children: List<String>.from(memberData['children']),
                groupAffiliate: List<String>.from(memberData['groupAffiliate']),
                profilePic: memberData['profilePic'],
                relativeContact: memberData['relativeContact'],
                role: memberData['role'],
                spouseName: memberData['spouseName'],
              );
            })
            .cast<Member>()
            .toList() ??
        [];

    return AttendanceModel(
      id: id,
      members: members,
      createdAt: (data['createdAt'] as Timestamp)
          .toDate(), // Convert Firestore Timestamp
      event: data['event'] as String,
    );
  }
}
