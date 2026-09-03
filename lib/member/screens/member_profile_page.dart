import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import 'membership_card_page.dart';

class MemberProfilePage extends StatefulWidget {
  const MemberProfilePage({
    super.key,
  });

  @override
  State<MemberProfilePage> createState() => _MemberProfilePageState();
}

class _MemberProfilePageState extends State<MemberProfilePage> {
  bool _loading = true;
  String? _error;

  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _phone = '';
  String _memberNumber = '';
  String _membershipStatus = '';
  String _organizationUnitId = '';

  @override
  void initState() {
    super.initState();
    _loadMemberProfile();
  }

  Future<void> _loadMemberProfile() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      // ========================================================
      // 1. Récupérer l'utilisateur actuellement connecté
      // ========================================================

      final meResponse = await ApiService.get(
        '/auth/me',
      );

      if (meResponse is! Map<String, dynamic>) {
        throw Exception(
          'Réponse utilisateur invalide.',
        );
      }

      final user = meResponse;

      _firstName = user['first_name']?.toString() ?? '';
      _lastName = user['last_name']?.toString() ?? '';
      _email = user['email']?.toString() ?? '';
      _phone = user['phone']?.toString() ?? '';

      // ========================================================
      // 2. Récupérer le member_id
      //
      // IMPORTANT :
      // L'utilisateur n'a un member_id qu'après approbation
      // de sa demande d'adhésion.
      // ========================================================

      final memberId = user['member_id']?.toString();

      if (memberId == null || memberId.isEmpty) {
        _memberNumber = '';
        _membershipStatus = '';
        _organizationUnitId = '';
      } else {
        // ======================================================
        // 3. Récupérer le membre correspondant
        // ======================================================

        final memberResponse = await ApiService.get(
          '/members/$memberId',
        );

        if (memberResponse is Map<String, dynamic>) {
          _memberNumber = memberResponse['member_number']?.toString() ?? '';

          _membershipStatus =
              memberResponse['membership_status']?.toString() ?? '';

          _organizationUnitId =
              memberResponse['organization_unit_id']?.toString() ?? '';
        }
      }

      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint(
        'Erreur chargement profil membre : $e',
      );

      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Impossible de charger votre profil membre.\n'
              'Vérifiez votre connexion au serveur.';
        });
      }
    }
  }

  // ==========================================================
  // NOM COMPLET
  // ==========================================================

  String get _fullName {
    final name = '$_firstName $_lastName'.trim();

    if (name.isEmpty) {
      return 'Nom non renseigné';
    }

    return name;
  }

  // ==========================================================
  // STATUT
  // ==========================================================

  String get _displayStatus {
    switch (_membershipStatus.toUpperCase()) {
      case 'ACTIVE':
        return 'Membre actif';

      case 'PENDING':
        return 'En attente';

      case 'SUSPENDED':
        return 'Membre suspendu';

      case 'REJECTED':
        return 'Adhésion rejetée';

      default:
        return _membershipStatus.isEmpty
            ? 'Statut non renseigné'
            : _membershipStatus;
    }
  }

  Color get _statusColor {
    switch (_membershipStatus.toUpperCase()) {
      case 'ACTIVE':
        return Colors.green;

      case 'PENDING':
        return Colors.orange;

      case 'SUSPENDED':
      case 'REJECTED':
        return Colors.red;

      default:
        return const Color(0xFFB00020);
    }
  }

  // ==========================================================
  // EMAIL
  // ==========================================================

  String get _displayEmail {
    if (_email.isEmpty) {
      return 'E-mail non renseigné';
    }

    return _email;
  }

  // ==========================================================
  // TELEPHONE
  // ==========================================================

  String get _displayPhone {
    if (_phone.isEmpty) {
      return 'Téléphone non renseigné';
    }

    return _phone;
  }

  // ==========================================================
  // NUMERO DE MEMBRE
  // ==========================================================

  String get _displayMemberNumber {
    if (_memberNumber.isEmpty) {
      return 'Numéro non disponible';
    }

    return _memberNumber;
  }

  // ==========================================================
  // STRUCTURE
  // ==========================================================

  String get _displayStructure {
    if (_organizationUnitId.isEmpty) {
      return 'MNPC SABOUWA';
    }

    return 'MNPC SABOUWA\nUnité : $_organizationUnitId';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mon profil membre',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _loadMemberProfile,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 25),
                    if (_error != null)
                      _buildErrorCard()
                    else
                      _buildProfileInformation(),
                  ],
                ),
              ),
            ),
    );
  }

  // ==========================================================
  // EN-TETE
  // ==========================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFB00020),
            Color(0xFF1B7F35),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.25,
                  ),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/mnpc_logo.jpg',
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return const Icon(
                    Icons.account_circle,
                    size: 90,
                    color: Color(0xFFB00020),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'MNPC SABOUWA',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Espace membre officiel',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          if (!_loading && _error == null) ...[
            const SizedBox(height: 18),
            Text(
              _fullName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================================
  // ERREUR
  // ==========================================================

  Widget _buildErrorCard() {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.info_outline,
              color: Colors.orange,
              size: 45,
            ),
            const SizedBox(height: 12),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _loadMemberProfile,
              icon: const Icon(Icons.refresh),
              label: const Text('Actualiser'),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // INFORMATIONS PROFIL
  // ==========================================================

  Widget _buildProfileInformation() {
    return Column(
      children: [
        _infoCard(
          icon: Icons.badge_outlined,
          title: 'Numéro membre',
          value: _displayMemberNumber,
          color: const Color(0xFFB00020),
        ),
        _infoCard(
          icon: Icons.verified_user_outlined,
          title: 'Statut du compte',
          value: _displayStatus,
          color: _statusColor,
        ),
        _infoCard(
          icon: Icons.person_outline,
          title: 'Nom complet',
          value: _fullName,
        ),
        _infoCard(
          icon: Icons.email_outlined,
          title: 'Adresse e-mail',
          value: _displayEmail,
        ),
        _infoCard(
          icon: Icons.phone_outlined,
          title: 'Téléphone',
          value: _displayPhone,
        ),
        _infoCard(
          icon: Icons.account_tree_outlined,
          title: 'Structure',
          value: _displayStructure,
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Text(
            'Votre adhésion contribue à la paix, '
            'l’union et au changement.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _memberNumber.isEmpty ||
                    _membershipStatus.toUpperCase() != 'ACTIVE'
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MembershipCardPage(),
                      ),
                    );
                  },
            icon: const Icon(Icons.badge_outlined),
            label: const Text(
              'Voir ma carte de membre',
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // CARTE D'INFORMATION
  // ==========================================================

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    Color? color,
  }) {
    final iconColor = color ?? const Color(0xFFB00020);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withValues(
            alpha: 0.15,
          ),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
