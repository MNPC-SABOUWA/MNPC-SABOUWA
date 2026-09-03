class UserModel {
  final String id;

  final String email;

  final String firstName;

  final String lastName;

  final String phone;

  final String role;

  final String accountStatus;

  final bool emailVerified;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.role,
    required this.accountStatus,
    required this.emailVerified,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserModel(
      id: json["id"].toString(),
      email: json["email"] ?? "",
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      phone: json["phone"] ?? "",
      role: json["role"] ?? "MEMBRE",
      accountStatus: json["account_status"] ?? "PENDING",
      emailVerified: json["email_verified"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "role": role,
      "account_status": accountStatus,
      "email_verified": emailVerified,
    };
  }
}
