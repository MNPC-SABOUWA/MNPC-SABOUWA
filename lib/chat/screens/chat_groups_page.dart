import 'package:flutter/material.dart';

import '../models/chat_group_model.dart';
import 'chat_room_page.dart';

class ChatGroupsPage extends StatelessWidget {
  const ChatGroupsPage({
    super.key,
  });

  List<ChatGroupModel> get groups => [
        ChatGroupModel(
          id: "1",
          name: "Coordination Nationale",
          description:
              "Espace de discussion de la Coordination Nationale de la MNPC SABOUWA.",
          membersCount: 120,
        ),
        ChatGroupModel(
          id: "2",
          name: "Coordination Régionale",
          description:
              "Espace de discussion des coordinations régionales et de leurs membres.",
          membersCount: 85,
        ),
        ChatGroupModel(
          id: "3",
          name: "Coordination Départementale",
          description:
              "Espace de discussion des coordinations départementales et de leurs membres.",
          membersCount: 60,
        ),
        ChatGroupModel(
          id: "4",
          name: "Coordination Communale",
          description:
              "Espace de discussion des coordinations communales et de leurs membres.",
          membersCount: 50,
        ),
        ChatGroupModel(
          id: "5",
          name: "Coordination Locale / Village",
          description:
              "Espace de discussion des coordinations locales et des membres des villages.",
          membersCount: 45,
        ),
        ChatGroupModel(
          id: "6",
          name: "Jeunesse MNPC",
          description: "Espace d'échange et d'organisation des jeunes membres.",
          membersCount: 60,
        ),
      ];

  void _openGroup(
    BuildContext context,
    ChatGroupModel group,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatRoomPage(
          group: group,
        ),
      ),
    );
  }

  IconData _groupIcon(String name) {
    if (name.contains('Nationale')) {
      return Icons.account_balance;
    }

    if (name.contains('Régionale')) {
      return Icons.location_city;
    }

    if (name.contains('Départementale')) {
      return Icons.map_outlined;
    }

    if (name.contains('Communale')) {
      return Icons.location_on_outlined;
    }

    if (name.contains('Locale') || name.contains('Village')) {
      return Icons.home_work_outlined;
    }

    if (name.contains('Jeunesse')) {
      return Icons.groups;
    }

    return Icons.forum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discussion MNPC SABOUWA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
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
            child: const Column(
              children: [
                Icon(
                  Icons.forum_rounded,
                  size: 55,
                  color: Colors.white,
                ),
                SizedBox(height: 12),
                Text(
                  'Espace de discussion',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Échangez avec les membres du mouvement',
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
          ...groups.map(
            (group) {
              return Card(
                elevation: 5,
                margin: const EdgeInsets.only(
                  bottom: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(
                      0xFFB00020,
                    ).withValues(
                      alpha: 0.15,
                    ),
                    child: Icon(
                      _groupIcon(group.name),
                      color: const Color(
                        0xFFB00020,
                      ),
                    ),
                  ),
                  title: Text(
                    group.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(
                      top: 6,
                    ),
                    child: Text(
                      '${group.description}\n'
                      '${group.membersCount} membres',
                    ),
                  ),
                  isThreeLine: true,
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    _openGroup(
                      context,
                      group,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
