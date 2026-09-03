import 'package:flutter/material.dart';

import '../../services/api_service.dart';

class PaymentCreatePage extends StatefulWidget {
  const PaymentCreatePage({
    super.key,
  });

  @override
  State<PaymentCreatePage> createState() => _PaymentCreatePageState();
}

class _PaymentCreatePageState extends State<PaymentCreatePage> {
  final amountController = TextEditingController(
    text: "2000",
  );

  final referenceController = TextEditingController();

  String paymentMethod = "Airtel Money";

  bool loading = false;

  final List<String> methods = [
    "Airtel Money",
    "NITA Transfert",
    "Amana Transfert",
  ];

  Future<void> sendPayment() async {
    setState(() {
      loading = true;
    });

    try {
      await ApiService.post(
        "/membership-payments/",
        {
          "amount": double.parse(
            amountController.text,
          ),
          "payment_method": paymentMethod,
          "transaction_reference": referenceController.text,
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Cotisation envoyée avec succès. En attente de validation.",
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Erreur : $e",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nouvelle cotisation",
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Moyen de paiement",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: paymentMethod,
              items: methods.map(
                (method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(method),
                  );
                },
              ).toList(),
              onChanged: (value) {
                setState(() {
                  paymentMethod = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Montant FCFA",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: referenceController,
              decoration: const InputDecoration(
                labelText: "Référence de transaction",
                hintText: "Ex: numéro reçu",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : sendPayment,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Envoyer la cotisation",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
