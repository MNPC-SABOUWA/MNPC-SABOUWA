import 'package:flutter/material.dart';

import '../../services/api_service.dart';

class AdminMembershipRequestsPage extends StatefulWidget {
  const AdminMembershipRequestsPage({
    super.key,
  });

  @override
  State<AdminMembershipRequestsPage> createState() =>
      _AdminMembershipRequestsPageState();
}

class _AdminMembershipRequestsPageState
    extends State<AdminMembershipRequestsPage> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _requests = [];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final response = await ApiService.get('/membership/');

      if (response is! List) {
        throw Exception('Réponse invalide du serveur.');
      }

      final requests = <Map<String, dynamic>>[];

      for (final item in response) {
        if (item is Map) {
          requests.add(
            Map<String, dynamic>.from(item),
          );
        }
      }

      if (mounted) {
        setState(() {
          _requests = requests;
          _loading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.message;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Impossible de charger les demandes.';
        });
      }
    }
  }

  Future<void> _approveRequest(
    String requestId,
  ) async {
    try {
      await ApiService.post(
        '/membership/$requestId/approve',
        {},
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Demande approuvée. Le membre a été créé automatiquement.',
          ),
        ),
      );

      await _loadRequests();
    } on ApiException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.message),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Impossible d’approuver la demande.',
          ),
        ),
      );
    }
  }

  Future<void> _rejectRequest(
    String requestId,
  ) async {
    try {
      await ApiService.post(
        '/membership/$requestId/reject',
        {},
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text(
            'Demande rejetée.',
          ),
        ),
      );

      await _loadRequests();
    } on ApiException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.message),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Impossible de rejeter la demande.',
          ),
        ),
      );
    }
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return 'APPROUVÉE';
      case 'REJECTED':
        return 'REJETÉE';
      default:
        return 'EN ATTENTE';
    }
  }

  String _paymentLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PAID':
        return 'PAYÉ';
      case 'REJECTED':
        return 'REJETÉ';
      default:
        return 'EN ATTENTE';
    }
  }

  Color _paymentColor(String status) {
    switch (status.toUpperCase()) {
      case 'PAID':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _date(String? value) {
    if (value == null || value.isEmpty) {
      return 'Non renseignée';
    }

    try {
      final date = DateTime.parse(value);

      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    } catch (_) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Demandes d’adhésion',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadRequests,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 55,
              ),
              const SizedBox(height: 15),
              Text(
                _error!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _loadRequests,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    if (_requests.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadRequests,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 180),
            Icon(
              Icons.inbox_outlined,
              size: 70,
              color: Colors.black26,
            ),
            SizedBox(height: 15),
            Center(
              child: Text(
                'Aucune demande d’adhésion.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRequests,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _requests.length,
        itemBuilder: (context, index) {
          return _buildRequestCard(
            _requests[index],
          );
        },
      ),
    );
  }

  Widget _buildRequestCard(
    Map<String, dynamic> request,
  ) {
    final requestId = request['id']?.toString() ?? '';

    final status = request['status']?.toString() ?? 'PENDING';

    final paymentStatus = request['payment_status']?.toString() ?? 'PENDING';

    final userId = request['user_id']?.toString() ?? '';

    final message = request['message']?.toString() ?? '';

    final address = request['address']?.toString() ?? '';

    final receiptReference = request['receipt_reference']?.toString() ?? '';

    final createdAt = request['created_at']?.toString();

    final cardFee = request['card_fee']?.toString() ?? '2000';

    final statusColor = _statusColor(status);

    final paymentColor = _paymentColor(paymentStatus);

    final isPending = status.toUpperCase() == 'PENDING';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  child: Icon(
                    Icons.person_outline,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Demande d’adhésion',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Utilisateur : $userId',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                _badge(
                  _statusLabel(status),
                  statusColor,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _infoLine(
              Icons.location_on_outlined,
              'Adresse',
              address.isEmpty ? 'Non renseignée' : address,
            ),
            const SizedBox(height: 8),
            _infoLine(
              Icons.message_outlined,
              'Message',
              message.isEmpty ? 'Aucun message' : message,
            ),
            const SizedBox(height: 8),
            _infoLine(
              Icons.payments_outlined,
              'Montant',
              '$cardFee F CFA',
            ),
            const SizedBox(height: 8),
            _infoLine(
              Icons.receipt_long_outlined,
              'Référence',
              receiptReference.isEmpty ? 'Non renseignée' : receiptReference,
            ),
            const SizedBox(height: 8),
            _infoLine(
              Icons.calendar_today_outlined,
              'Date',
              _date(createdAt),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Paiement : ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _badge(
                  _paymentLabel(paymentStatus),
                  paymentColor,
                ),
              ],
            ),
            if (isPending) ...[
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: requestId.isEmpty
                          ? null
                          : () => _rejectRequest(
                                requestId,
                              ),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Rejeter',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: requestId.isEmpty ||
                              paymentStatus.toUpperCase() != 'PAID'
                          ? null
                          : () => _approveRequest(
                                requestId,
                              ),
                      icon: const Icon(
                        Icons.check,
                      ),
                      label: const Text(
                        'Approuver',
                      ),
                    ),
                  ),
                ],
              ),
              if (paymentStatus.toUpperCase() != 'PAID') ...[
                const SizedBox(height: 8),
                const Text(
                  'Le paiement doit être vérifié avant '
                  'l’approbation de la demande.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoLine(
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 19,
          color: Colors.black54,
        ),
        const SizedBox(width: 8),
        Text(
          '$label : ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _badge(
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
