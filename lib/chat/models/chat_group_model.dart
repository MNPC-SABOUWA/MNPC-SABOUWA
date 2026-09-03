class ChatGroupModel {
  final String id;
  final String name;
  final String description;
  final int membersCount;

  ChatGroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.membersCount,
  });

  factory ChatGroupModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ChatGroupModel(
      id: json["id"].toString(),
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      membersCount: json["members_count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "members_count": membersCount,
    };
  }
}
