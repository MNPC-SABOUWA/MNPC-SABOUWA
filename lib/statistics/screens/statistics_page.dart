import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../models/statistic_model.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({
    super.key,
  });

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool loading = true;

  String? error;

  List<StatisticModel> statistics = [];

  @override
  void initState() {
    super.initState();

    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      final response = await ApiService.get(
        '/statistics/',
      );

      if (response is List) {
        statistics = response
            .whereType<Map<String, dynamic>>()
            .map(
              StatisticModel.fromJson,
            )
            .toList();
      }
    } catch (e) {
      error = 'Impossible de charger les statistiques.';
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Widget statisticCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Icon(
                icon,
                size: 35,
                color: Colors.green,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistiques MNPC SABOUWA',
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
              : statistics.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucune statistique disponible.',
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: statistics.length,
                      itemBuilder: (context, index) {
                        final item = statistics[index];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
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
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.bar_chart,
                                    color: Colors.white,
                                    size: 55,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    item.statisticType,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${item.year}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                statisticCard(
                                  icon: Icons.people,
                                  title: 'Membres',
                                  value: '${item.totalMembers}',
                                ),
                                statisticCard(
                                  icon: Icons.man,
                                  title: 'Hommes',
                                  value: '${item.totalMen}',
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                statisticCard(
                                  icon: Icons.woman,
                                  title: 'Femmes',
                                  value: '${item.totalWomen}',
                                ),
                                statisticCard(
                                  icon: Icons.school,
                                  title: 'Jeunes',
                                  value: '${item.totalYouth}',
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Card(
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Zone administrative',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Région : ${item.region ?? "-"}',
                                    ),
                                    Text(
                                      'Département : ${item.department ?? "-"}',
                                    ),
                                    Text(
                                      'Commune : ${item.commune ?? "-"}',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                          ],
                        );
                      },
                    ),
    );
  }
}
