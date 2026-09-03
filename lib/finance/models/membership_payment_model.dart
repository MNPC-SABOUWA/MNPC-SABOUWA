class MembershipPaymentModel {
  final String id;
  final String memberId;
  final double amount;
  final String paymentMethod;
  final String? transactionReference;
  final String? receiptUrl;
  final String paymentStatus;
  final String? verifiedBy;
  final String createdAt;
  final String? verifiedAt;

  const MembershipPaymentModel({
    required this.id,
    required this.memberId,
    required this.amount,
    required this.paymentMethod,
    this.transactionReference,
    this.receiptUrl,
    required this.paymentStatus,
    this.verifiedBy,
    required this.createdAt,
    this.verifiedAt,
  });

  factory MembershipPaymentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MembershipPaymentModel(
      id: json["id"]?.toString() ?? "",
      memberId: json["member_id"]?.toString() ?? "",
      amount: double.tryParse(
            json["amount"]?.toString() ?? "",
          ) ??
          0,
      paymentMethod: json["payment_method"]?.toString() ?? "",
      transactionReference: json["transaction_reference"]?.toString(),
      receiptUrl: json["receipt_url"]?.toString(),
      paymentStatus: json["payment_status"]?.toString() ?? "",
      verifiedBy: json["verified_by"]?.toString(),
      createdAt: json["created_at"]?.toString() ?? "",
      verifiedAt: json["verified_at"]?.toString(),
    );
  }
}
