class AppUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String role;
  final String accountStatus;
  final bool emailVerified;
  final String? memberId;

  const AppUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.accountStatus,
    required this.emailVerified,
    this.phone,
    this.memberId,
  });

  String get fullName => '$firstName $lastName'.trim();

  AppUser copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? role,
    String? accountStatus,
    bool? emailVerified,
    String? memberId,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      accountStatus: accountStatus ?? this.accountStatus,
      emailVerified: emailVerified ?? this.emailVerified,
      memberId: memberId ?? this.memberId,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      phone: json['phone']?.toString(),
      role: json['role']?.toString() ?? 'MEMBRE',
      accountStatus: json['account_status']?.toString() ?? 'PENDING',
      emailVerified: json['email_verified'] == true,
      memberId: json['member_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'role': role,
      'account_status': accountStatus,
      'email_verified': emailVerified,
      'member_id': memberId,
    };
  }
}
