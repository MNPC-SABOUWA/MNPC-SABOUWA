import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../models/finance_model.dart';
import 'payment_create_page.dart';
import 'payment_history_page.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({
    super.key,
  });

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  bool loading = true;

  String? error;

  List<FinanceModel> transactions = [];

  @override
  void initState() {
    super.initState();

    _loadFinance();
  }

  Future<void> _loadFinance() async {
    try {
      final response = await ApiService.get(
        '/finance/',
      );

      if (response is List) {
        transactions = response
            .whereType<Map<String, dynamic>>()
            .map(
              FinanceModel.fromJson,
            )
            .toList();
      }
    } catch (e) {
      error = 'Impossible de charger les données financières.';
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  double get total {
    return transactions.fold(
      0,
      (sum, item) => sum + item.amount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Finance MNPC SABOUWA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFB00020),
                              Color(0xFF1B7F35),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.account_balance_wallet,
                              size: 55,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Text(
                              'Situation financière',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              '${total.toStringAsFixed(0)} FCFA',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text(
                        'Cotisation membre',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                Icons.add_card,
                              ),
                              label: const Text(
                                'Payer',
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PaymentCreatePage(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                Icons.history,
                              ),
                              label: const Text(
                                'Historique',
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PaymentHistoryPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Historique des opérations',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      transactions.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(30),
                                child: Text(
                                  'Aucune opération financière.',
                                ),
                              ),
                            )
                          : Column(
                              children: transactions.map(
                                (transaction) {
                                  return Card(
                                    elevation: 5,
                                    margin: const EdgeInsets.only(
                                      bottom: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(15),
                                      leading: const CircleAvatar(
                                        backgroundColor: Color(0xFFE8F5E9),
                                        child: Icon(
                                          Icons.payments,
                                          color: Colors.green,
                                        ),
                                      ),
                                      title: Text(
                                        transaction.transactionType,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        transaction.description ??
                                            'Opération financière',
                                      ),
                                      trailing: Text(
                                        '${transaction.amount.toStringAsFixed(0)} FCFA',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                    ],
                  ),
                ),
    );
  }
}
