import 'package:flutter/material.dart';

import '../../chat/screens/chat_groups_page.dart';
import '../../news/screens/news_page.dart';
import 'admin_membership_requests_page.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({
    super.key,
  });

  void _showComingSoon(
    BuildContext context,
    String title,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$title : module en cours de finalisation.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Administration MNPC SABOUWA',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                child: const Column(
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                      size: 60,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Espace Administrateur',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Gestion et supervision de MNPC SABOUWA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Gestion du système',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.05,
                  children: [
                    _adminCard(
                      context,
                      icon: Icons.people,
                      title: 'Membres',
                      onTap: () {
                        _showComingSoon(
                          context,
                          'Membres',
                        );
                      },
                    ),
                    _adminCard(
                      context,
                      icon: Icons.assignment,
                      title: 'Demandes',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminMembershipRequestsPage(),
                          ),
                        );
                      },
                    ),
                    _adminCard(
                      context,
                      icon: Icons.payments,
                      title: 'Paiements',
                      onTap: () {
                        _showComingSoon(
                          context,
                          'Paiements',
                        );
                      },
                    ),
                    _adminCard(
                      context,
                      icon: Icons.folder,
                      title: 'Documents',
                      onTap: () {
                        _showComingSoon(
                          context,
                          'Documents',
                        );
                      },
                    ),
                    _adminCard(
                      context,
                      icon: Icons.newspaper,
                      title: 'Actualités',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NewsPage(),
                          ),
                        );
                      },
                    ),
                    _adminCard(
                      context,
                      icon: Icons.notifications,
                      title: 'Notifications',
                      onTap: () {
                        _showComingSoon(
                          context,
                          'Notifications',
                        );
                      },
                    ),
                    _adminCard(
                      context,
                      icon: Icons.chat,
                      title: 'Discussions',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChatGroupsPage(),
                          ),
                        );
                      },
                    ),
                    _adminCard(
                      context,
                      icon: Icons.settings,
                      title: 'Paramètres',
                      onTap: () {
                        _showComingSoon(
                          context,
                          'Paramètres',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _adminCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  size: 38,
                  color: const Color(0xFF1B7F35),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
