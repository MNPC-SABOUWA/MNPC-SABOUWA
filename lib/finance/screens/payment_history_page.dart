import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../models/membership_payment_model.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({
    super.key,
  });

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  bool loading = true;

  String? error;

  List<MembershipPaymentModel> payments = [];

  @override
  void initState() {
    super.initState();

    _loadPayments();
  }

  Future<void> _loadPayments() async {
    try {
      final response = await ApiService.get(
        "/membership-payments/",
      );

      if (response is List) {
        payments = response
            .whereType<Map<String, dynamic>>()
            .map(
              MembershipPaymentModel.fromJson,
            )
            .toList();
      }
    } catch (e) {
      error = "Impossible de charger les cotisations.";
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case "validated":
      case "validé":
        return Colors.green;

      case "rejected":
      case "refusé":
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mes cotisations",
        ),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error != null
              ? Center(
                  child: Text(error!),
                )
              : payments.isEmpty
                  ? const Center(
                      child: Text(
                        "Aucune cotisation enregistrée.",
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: payments.length,
                      itemBuilder: (context, index) {
                        final payment = payments[index];

                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.only(
                            bottom: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              18,
                            ),
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(
                                Icons.payment,
                              ),
                            ),
                            title: Text(
                              "${payment.amount.toStringAsFixed(0)} FCFA",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  payment.paymentMethod,
                                ),
                                if (payment.transactionReference != null)
                                  Text(
                                    "Référence : ${payment.transactionReference}",
                                  ),
                              ],
                            ),
                            trailing: Text(
                              payment.paymentStatus,
                              style: TextStyle(
                                color: statusColor(
                                  payment.paymentStatus,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
