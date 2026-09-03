class FinanceModel {
  final String id;
  final String? memberId;
  final String transactionType;
  final double amount;
  final String? description;
  final String status;
  final String createdAt;

  const FinanceModel({
    required this.id,
    this.memberId,
    required this.transactionType,
    required this.amount,
    this.description,
    required this.status,
    required this.createdAt,
  });

  factory FinanceModel.fromJson(Map<String, dynamic> json) {
    return FinanceModel(
      id: json['id']?.toString() ?? '',
      memberId: json['member_id']?.toString(),
      transactionType: json['transaction_type']?.toString() ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '') ?? 0,
      description: json['description']?.toString(),
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
