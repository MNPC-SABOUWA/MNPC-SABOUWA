import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/storage_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _email = '';
  String _phone = '';
  String _status = '';
  String _memberNumber = '';
  String _fullName = '';

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInformation();
  }

  Future<void> _loadUserInformation() async {
    try {
      final userJson = await StorageService.getUser();

      if (userJson == null || userJson.isEmpty) {
        if (!mounted) {
          return;
        }

        setState(() {
          _loading = false;
        });

        return;
      }

      final user = _decodeUser(userJson);

      if (!mounted) {
        return;
      }

      setState(() {
        _email = user['email']?.toString() ?? '';
        _phone = user['phone']?.toString() ?? '';

        final firstName = user['first_name']?.toString() ?? '';

        final lastName = user['last_name']?.toString() ?? '';

        _fullName = '$firstName $lastName'.trim();

        _status = user['account_status']?.toString() ?? '';

        _memberNumber = user['member_number']?.toString() ?? '';

        _loading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
      });
    }
  }

  Map<String, dynamic> _decodeUser(
    String value,
  ) {
    try {
      final decoded = _jsonDecode(value);

      if (decoded is Map) {
        return Map<String, dynamic>.from(
          decoded,
        );
      }
    } catch (_) {}

    return {};
  }

  dynamic _jsonDecode(
    String value,
  ) {
    return const _JsonDecoder().decode(value);
  }

  String _displayValue(
    String value,
    String fallback,
  ) {
    if (value.trim().isEmpty) {
      return fallback;
    }

    return value;
  }

  String _statusLabel() {
    switch (_status.toUpperCase()) {
      case 'ACTIVE':
        return 'Compte actif';

      case 'PENDING':
        return 'Compte en attente';

      case 'SUSPENDED':
        return 'Compte suspendu';

      default:
        return _displayValue(
          _status,
          'Non renseigné',
        );
    }
  }

  Color _statusColor() {
    switch (_status.toUpperCase()) {
      case 'ACTIVE':
        return Colors.green;

      case 'SUSPENDED':
        return Colors.red;

      case 'PENDING':
      default:
        return Colors.orange;
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Déconnexion',
          ),
          content: const Text(
            'Voulez-vous vraiment vous déconnecter '
            'de votre compte MNPC SABOUWA ?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Annuler',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'Se déconnecter',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await AuthService().logout();

    if (!mounted) {
      return;
    }

    Navigator.of(context).popUntil(
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paramètres',
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
              onRefresh: _loadUserInformation,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 22),
                  _buildSectionTitle(
                    'Mon compte',
                  ),
                  const SizedBox(height: 10),
                  _buildInfoCard(
                    icon: Icons.person_outline,
                    title: 'Nom complet',
                    value: _displayValue(
                      _fullName,
                      'Non renseigné',
                    ),
                  ),
                  _buildInfoCard(
                    icon: Icons.email_outlined,
                    title: 'Adresse e-mail',
                    value: _displayValue(
                      _email,
                      'Non renseignée',
                    ),
                  ),
                  _buildInfoCard(
                    icon: Icons.phone_outlined,
                    title: 'Téléphone',
                    value: _displayValue(
                      _phone,
                      'Non renseigné',
                    ),
                  ),
                  _buildInfoCard(
                    icon: Icons.badge_outlined,
                    title: 'Numéro de membre',
                    value: _displayValue(
                      _memberNumber,
                      'Pas encore attribué',
                    ),
                  ),
                  const SizedBox(height: 22),
                  _buildSectionTitle(
                    'Sécurité du compte',
                  ),
                  const SizedBox(height: 10),
                  _buildSecurityCard(),
                  const SizedBox(height: 22),
                  _buildSectionTitle(
                    'Application',
                  ),
                  const SizedBox(height: 10),
                  _buildActionCard(
                    icon: Icons.info_outline,
                    title: 'À propos de MNPC SABOUWA',
                    subtitle:
                        'Informations officielles et version de l’application.',
                    onTap: _showAbout,
                  ),
                  const SizedBox(height: 22),
                  _buildLogoutButton(),
                  const SizedBox(height: 30),
                  const Center(
                    child: Text(
                      'MNPC SABOUWA\n'
                      'Ensemble pour la Paix et le Changement',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    final color = _statusColor();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFB00020),
            Color(0xFF1B7F35),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.settings_outlined,
              color: Color(0xFFB00020),
              size: 38,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Paramètres du compte',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  _statusLabel(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    backgroundColor: color.withValues(
                      alpha: 0.25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
  ) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFB00020).withValues(
            alpha: 0.10,
          ),
          child: Icon(
            icon,
            color: const Color(0xFFB00020),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(
            top: 4,
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.withValues(
                    alpha: 0.12,
                  ),
                  child: const Icon(
                    Icons.verified_user_outlined,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Adresse e-mail vérifiée',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Votre adresse e-mail a été vérifiée.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ],
            ),
            const Divider(
              height: 28,
            ),
            const Row(
              children: [
                Icon(
                  Icons.lock_outline,
                  color: Color(0xFFB00020),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Votre session est protégée par '
                    'l’authentification du compte.',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 6,
        ),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1B7F35).withValues(
            alpha: 0.12,
          ),
          child: Icon(
            icon,
            color: const Color(0xFF1B7F35),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
        ),
        trailing: const Icon(
          Icons.chevron_right,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: _logout,
        icon: const Icon(
          Icons.logout,
          color: Colors.red,
        ),
        label: const Text(
          'Se déconnecter',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Colors.red,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  void _showAbout() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'MNPC SABOUWA',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const SingleChildScrollView(
            child: Text(
              'MOUVEMENT NIGÉRIENS POUR LA PAIX '
              'ET LE CHANGEMENT\n\n'
              '(MNPC/SABOUWA)\n\n'
              '« Ensemble pour la Paix et le Changement »\n\n'
              'Application officielle destinée aux '
              'membres du mouvement.\n\n'
              'Version : 1.0.0',
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: const Text(
                'Fermer',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _JsonDecoder {
  const _JsonDecoder();

  dynamic decode(String source) {
    final trimmed = source.trim();

    if (trimmed.isEmpty) {
      return null;
    }

    return _parseValue(
      trimmed,
      0,
    ).$1;
  }

  (dynamic, int) _parseValue(
    String source,
    int index,
  ) {
    while (index < source.length && source.codeUnitAt(index) <= 32) {
      index++;
    }

    if (index >= source.length) {
      return (null, index);
    }

    final char = source[index];

    if (char == '{') {
      final map = <String, dynamic>{};

      index++;

      while (index < source.length) {
        while (index < source.length && source.codeUnitAt(index) <= 32) {
          index++;
        }

        if (index < source.length && source[index] == '}') {
          return (map, index + 1);
        }

        final keyResult = _parseString(
          source,
          index,
        );

        final key = keyResult.$1 as String;

        index = keyResult.$2;

        while (index < source.length && source[index] != ':') {
          index++;
        }

        index++;

        final valueResult = _parseValue(
          source,
          index,
        );

        map[key] = valueResult.$1;

        index = valueResult.$2;

        while (index < source.length && source.codeUnitAt(index) <= 32) {
          index++;
        }

        if (index < source.length && source[index] == ',') {
          index++;
        }
      }
    }

    if (char == '"') {
      return _parseString(
        source,
        index,
      );
    }

    final start = index;

    while (index < source.length &&
        !',}]'.contains(
          source[index],
        )) {
      index++;
    }

    final value = source
        .substring(
          start,
          index,
        )
        .trim();

    if (value == 'true') {
      return (true, index);
    }

    if (value == 'false') {
      return (false, index);
    }

    if (value == 'null') {
      return (null, index);
    }

    return (value, index);
  }

  (dynamic, int) _parseString(
    String source,
    int index,
  ) {
    index++;

    final buffer = StringBuffer();

    while (index < source.length) {
      final char = source[index];

      if (char == '"') {
        return (
          buffer.toString(),
          index + 1,
        );
      }

      if (char == '\\' && index + 1 < source.length) {
        index++;

        final escaped = source[index];

        switch (escaped) {
          case 'n':
            buffer.write('\n');
            break;
          case 'r':
            buffer.write('\r');
            break;
          case 't':
            buffer.write('\t');
            break;
          default:
            buffer.write(escaped);
        }
      } else {
        buffer.write(char);
      }

      index++;
    }

    return (
      buffer.toString(),
      index,
    );
  }
}
