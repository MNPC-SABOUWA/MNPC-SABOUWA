import 'package:flutter/material.dart';

import '../models/news_model.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({
    super.key,
  });

  List<NewsModel> get newsList => [
        NewsModel(
          id: "1",
          title: "Bienvenue dans MNPC SABOUWA",
          content:
              "La plateforme numérique de la MNPC SABOUWA est ouverte aux membres.",
          author: "Administration",
          date: "23/08/2026",
        ),
        NewsModel(
          id: "2",
          title: "Nouvelle organisation",
          content:
              "Les membres peuvent maintenant consulter les informations de leur organisation.",
          author: "Bureau National",
          date: "23/08/2026",
        ),
        NewsModel(
          id: "3",
          title: "Réunion nationale",
          content: "Une réunion nationale sera organisée prochainement.",
          author: "Coordination",
          date: "23/08/2026",
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Actualités MNPC SABOUWA',
        ),
        centerTitle: true,
      ),
      body: ListView(
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
                  Icons.campaign_rounded,
                  color: Colors.white,
                  size: 55,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Informations officielles',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Ensemble pour la Paix et le Changement',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          ...newsList.map(
            (news) {
              return Card(
                elevation: 6,
                margin: const EdgeInsets.only(
                  bottom: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        news.content,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            news.author,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            news.date,
                          ),
                        ],
                      ),
                    ],
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
