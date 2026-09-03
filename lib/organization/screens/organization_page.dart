import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/organization_provider.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({super.key});

  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrganizationProvider>().loadUnits();
    });
  }

  IconData _getIcon(String type) {
    final value = type.toLowerCase();

    if (value.contains('national')) {
      return Icons.account_balance;
    }

    if (value.contains('regional')) {
      return Icons.location_city;
    }

    if (value.contains('depart')) {
      return Icons.groups;
    }

    if (value.contains('commune')) {
      return Icons.home_work;
    }

    return Icons.account_tree;
  }

  Color _getColor(String type) {
    final value = type.toLowerCase();

    if (value.contains('national')) {
      return const Color(0xFFB00020);
    }

    if (value.contains('regional')) {
      return const Color(0xFF1B7F35);
    }

    return const Color(0xFF1565C0);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrganizationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Organisation MNPC SABOUWA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: provider.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : provider.error != null
              ? Center(
                  child: Text(
                    provider.error!,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              : provider.units.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucune structure disponible.',
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(18),
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
                                Icons.account_tree_rounded,
                                color: Colors.white,
                                size: 55,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Structure nationale',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Mouvement Nigériens pour la Paix et le Changement',
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
                        ...provider.units.map(
                          (unit) {
                            final color = _getColor(unit.unitType);

                            return Card(
                              elevation: 5,
                              margin: const EdgeInsets.only(bottom: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(15),
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: color.withValues(
                                    alpha: 0.15,
                                  ),
                                  child: Icon(
                                    _getIcon(
                                      unit.unitType,
                                    ),
                                    color: color,
                                  ),
                                ),
                                title: Text(
                                  unit.name,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 6,
                                  ),
                                  child: Text(
                                    '${unit.unitType} • ${unit.code}',
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    unit.status,
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
    );
  }
}
