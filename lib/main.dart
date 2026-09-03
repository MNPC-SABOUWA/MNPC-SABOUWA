import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/providers/auth_provider.dart';
import 'auth/screens/login_page.dart';
import 'auth/screens/register_page.dart';
import 'auth/screens/verification_email_page.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

import 'dashboard/dashboard_page.dart';
import 'finance/screens/finance_page.dart';

import 'member/providers/member_provider.dart';
import 'member/screens/member_profile_page.dart';

import 'organization/providers/organization_provider.dart';
import 'organization/screens/organization_page.dart';

import 'statistics/screens/statistics_page.dart';
import 'splash/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MnpcSabouwaApp());
}

class MnpcSabouwaApp extends StatelessWidget {
  const MnpcSabouwaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MemberProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrganizationProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MNPC SABOUWA',
        theme: AppTheme.lightTheme,
        home: const SplashPage(),
        routes: {
          AppRoutes.login: (_) => const LoginPage(),
          AppRoutes.register: (_) => const RegisterPage(),
          AppRoutes.verifyEmail: (_) => const VerificationEmailPage(),
          AppRoutes.dashboard: (_) => const DashboardPage(),
          AppRoutes.memberProfile: (_) => const MemberProfilePage(),
          AppRoutes.organization: (_) => const OrganizationPage(),
          AppRoutes.statistics: (_) => const StatisticsPage(),
          AppRoutes.finance: (_) => const FinancePage(),
        },
      ),
    );
  }
}
