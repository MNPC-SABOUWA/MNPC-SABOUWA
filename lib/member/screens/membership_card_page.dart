import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../services/api_service.dart';

class MembershipCardPage extends StatefulWidget {
  const MembershipCardPage({super.key});

  @override
  State<MembershipCardPage> createState() => _MembershipCardPageState();
}

class _MembershipCardPageState extends State<MembershipCardPage> {
  bool loading = true;
  String? error;

  String firstName = '';
  String lastName = '';
  String memberNumber = '';
  String membershipStatus = '';
  String joinedAt = '';
  String expiresAt = '';

  @override
  void initState() {
    super.initState();
    _loadCard();
  }

  Future<void> _loadCard() async {
    try {
      final me = await ApiService.get('/auth/me');

      if (me is! Map<String, dynamic>) {
        throw Exception('Réponse utilisateur invalide.');
      }

      firstName = me['first_name']?.toString() ?? '';
      lastName = me['last_name']?.toString() ?? '';

      final memberId = me['member_id']?.toString();

      if (memberId == null || memberId.isEmpty) {
        throw Exception(
          'Votre demande d’adhésion n’est pas encore approuvée.',
        );
      }

      final member = await ApiService.get('/members/$memberId');

      if (member is! Map<String, dynamic>) {
        throw Exception('Profil membre introuvable.');
      }

      memberNumber = member['member_number']?.toString() ?? '';
      membershipStatus = member['membership_status']?.toString() ?? '';
      joinedAt = member['joined_at']?.toString() ?? '';

      if (membershipStatus.toUpperCase() != 'ACTIVE') {
        throw Exception(
          'Votre adhésion n’est pas encore active.',
        );
      }

      final requests = await ApiService.get('/membership/mine');

      if (requests is List) {
        for (final item in requests) {
          if (item is Map<String, dynamic> &&
              item['status']?.toString().toUpperCase() == 'APPROVED') {
            expiresAt = item['card_expires_at']?.toString() ?? '';

            if (joinedAt.isEmpty) {
              joinedAt = item['card_started_at']?.toString() ?? '';
            }

            break;
          }
        }
      }

      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
          error = e.toString().replaceFirst(
                'Exception: ',
                '',
              );
        });
      }
    }
  }

  String _date(String value) {
    if (value.isEmpty) {
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
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Carte de membre'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Carte de membre'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.credit_card_off,
                  size: 60,
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                Text(
                  error!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _loadCard,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Actualiser'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final qrData =
        'https://mnpc-sabouwa-api.onrender.com/members/$memberNumber';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Ma carte de membre',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFB00020),
                    Color(0xFF8B0000),
                    Color(0xFF1B7F35),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/mnpc_logo.jpg',
                    width: 70,
                    height: 70,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'MNPC SABOUWA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'CARTE DE MEMBRE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 25),
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/mnpc_logo.jpg',
                        width: 88,
                        height: 88,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '$firstName $lastName',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _row(
                    'Numéro',
                    memberNumber,
                  ),
                  _row(
                    'Statut',
                    'MEMBRE ACTIF',
                  ),
                  _row(
                    'Adhésion',
                    _date(joinedAt),
                  ),
                  _row(
                    'Expiration',
                    _date(expiresAt),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: QrImageView(
                      data: qrData,
                      size: 150,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'QR CODE DE VÉRIFICATION',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.verified,
                    color: Colors.green,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Cette carte est réservée aux membres dont '
                      'l’adhésion a été officiellement approuvée.',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
