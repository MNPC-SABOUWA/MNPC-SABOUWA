class NewsModel {
  final String id;
  final String title;
  final String content;
  final String author;
  final String date;
  final String? imageUrl;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.date,
    this.imageUrl,
  });

  factory NewsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return NewsModel(
      id: json["id"].toString(),
      title: json["title"] ?? "",
      content: json["content"] ?? "",
      author: json["author"] ?? "MNPC SABOUWA",
      date: json["date"] ?? "",
      imageUrl: json["image_url"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "author": author,
      "date": date,
      "image_url": imageUrl,
    };
  }
}
