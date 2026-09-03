class MemberModel {
  final String id;
  final String userId;
  final String? organizationUnitId;
  final String memberNumber;
  final String? birthDate;
  final String? gender;
  final String? profession;
  final String membershipStatus;
  final String? joinedAt;
  final String createdAt;
  final String updatedAt;

  const MemberModel({
    required this.id,
    required this.userId,
    this.organizationUnitId,
    required this.memberNumber,
    this.birthDate,
    this.gender,
    this.profession,
    required this.membershipStatus,
    this.joinedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      organizationUnitId: json['organization_unit_id']?.toString(),
      memberNumber: json['member_number']?.toString() ?? '',
      birthDate: json['birth_date']?.toString(),
      gender: json['gender']?.toString(),
      profession: json['profession']?.toString(),
      membershipStatus:
          json['membership_status']?.toString() ?? 'PENDING',
      joinedAt: json['joined_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'organization_unit_id': organizationUnitId,
      'member_number': memberNumber,
      'birth_date': birthDate,
      'gender': gender,
      'profession': profession,
      'membership_status': membershipStatus,
      'joined_at': joinedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
