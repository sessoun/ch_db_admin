class Member {
  String? id;
  final String fullName;
  final String location;
  final String contact;
  final String marriageStatus;
  final String? spouseName;
  final List<String>? children;
  final String? relativeContact;
  final String? additionalImage;
  final String? profilePic;
  final DateTime dateOfBirth;
  final List<String>? groupAffiliate;
  String? role;
  final MemberStatus status;

  Member({
    this.id,
    required this.fullName,
    required this.location,
    required this.contact,
    required this.marriageStatus,
    this.spouseName,
    this.children,
    this.relativeContact,
    this.additionalImage,
    this.profilePic,
    required this.dateOfBirth,
    this.groupAffiliate,
    this.role,
    required this.status,
  });
}

enum MemberStatus { newMember, active, inactive, visitor }
