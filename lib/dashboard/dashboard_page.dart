import 'package:flutter/material.dart';

import '../chat/screens/chat_groups_page.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../finance/screens/finance_page.dart';
import '../member/screens/member_profile_page.dart';
import '../membership/screens/membership_request_page.dart';
import '../news/screens/news_page.dart';
import '../organization/screens/organization_page.dart';
import '../settings/screens/settings_page.dart';
import '../statistics/screens/statistics_page.dart';
import 'widgets/dashboard_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
  });

  void _openPage(
    BuildContext context,
    Widget page,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: const Text(
          'MNPC SABOUWA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Aucune nouvelle notification.',
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_active_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrganizationHeader(),
              const SizedBox(height: 25),
              _buildWelcomeCard(),
              const SizedBox(height: 25),
              const Text(
                'Services MNPC SABOUWA',
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: 8),
              const Text(
                'Accédez rapidement aux espaces officiels de votre organisation.',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 20),
              DashboardCard(
                title: 'Actualités',
                icon: Icons.newspaper_outlined,
                subtitle: 'Informations, annonces et activités du mouvement.',
                color: AppColors.primary,
                onTap: () {
                  _openPage(
                    context,
                    const NewsPage(),
                  );
                },
              ),
              const SizedBox(height: 14),
              DashboardCard(
                title: 'Groupes de discussion',
                icon: Icons.forum_outlined,
                subtitle: 'Échanger avec les membres du MNPC SABOUWA.',
                color: AppColors.secondary,
                onTap: () {
                  _openPage(
                    context,
                    const ChatGroupsPage(),
                  );
                },
              ),
              const SizedBox(height: 14),
              DashboardCard(
                title: 'Mon profil',
                icon: Icons.account_circle_outlined,
                subtitle: 'Consulter vos informations personnelles.',
                color: AppColors.primary,
                onTap: () {
                  _openPage(
                    context,
                    const MemberProfilePage(),
                  );
                },
              ),
              const SizedBox(height: 14),
              DashboardCard(
                title: 'Demande d’adhésion',
                icon: Icons.how_to_reg_outlined,
                subtitle:
                    'Soumettre et suivre votre demande officielle d’adhésion.',
                color: AppColors.primary,
                onTap: () {
                  _openPage(
                    context,
                    const MembershipRequestPage(),
                  );
                },
              ),
              const SizedBox(height: 14),
              DashboardCard(
                title: 'Organisation',
                icon: Icons.account_tree_outlined,
                subtitle: 'Structure nationale et coordinations.',
                color: AppColors.secondary,
                onTap: () {
                  _openPage(
                    context,
                    const OrganizationPage(),
                  );
                },
              ),
              const SizedBox(height: 14),
              DashboardCard(
                title: 'Finances',
                icon: Icons.account_balance_wallet_outlined,
                subtitle: 'Suivi financier et transparence.',
                color: AppColors.success,
                onTap: () {
                  _openPage(
                    context,
                    const FinancePage(),
                  );
                },
              ),
              const SizedBox(height: 14),
              DashboardCard(
                title: 'Statistiques',
                icon: Icons.bar_chart_rounded,
                subtitle: 'Indicateurs et évolution du mouvement.',
                color: AppColors.info,
                onTap: () {
                  _openPage(
                    context,
                    const StatisticsPage(),
                  );
                },
              ),
              const SizedBox(height: 14),
              DashboardCard(
                title: 'Paramètres',
                icon: Icons.settings_outlined,
                subtitle: 'Gérer votre compte, la sécurité et les préférences.',
                color: AppColors.secondary,
                onTap: () {
                  _openPage(
                    context,
                    const SettingsPage(),
                  );
                },
              ),
              const SizedBox(height: 25),
              _buildSecurityCard(),
              const SizedBox(height: 20),
              _buildOfficialInformation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrganizationHeader() {
    return Center(
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
                  color: Colors.black.withValues(alpha: 0.20),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/mnpc_logo.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'MOUVEMENT NIGÉRIENS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B0000),
            ),
          ),
          const Text(
            'POUR LA PAIX ET LE CHANGEMENT',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '« Ensemble pour la Paix et le Changement »',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB00020),
            Color(0xFF7A0015),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(
            Icons.groups_rounded,
            size: 55,
            color: Colors.white,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenue',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Espace membre officiel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.green.shade300,
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.verified_user_outlined,
            color: Colors.green,
            size: 32,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Compte sécurisé : votre adresse e-mail est vérifiée.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficialInformation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations officielles',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'MOUVEMENT NIGÉRIENS POUR LA PAIX ET LE CHANGEMENT\n'
            '(MNPC/SABOUWA)',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '« Ensemble pour la Paix et le Changement »',
            style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Organisation reconnue par arrêté\n'
            'n°00644/MI/SP/AT/DGAPJ/DLP\n'
            'du 13 août 2026',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Siège social : Quartier Karkada, Zinder – Niger',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Téléphone : +227 97 94 61 62',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Email : officelmnpcsabouwa@gmail.com',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Facebook : MNPC Officiel',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
