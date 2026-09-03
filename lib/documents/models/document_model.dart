class DocumentModel {
  final String id;
  final String title;
  final String category;
  final String type;
  final String? description;
  final String? fileUrl;
  final String createdAt;

  const DocumentModel({
    required this.id,
    required this.title,
    required this.category,
    required this.type,
    this.description,
    this.fileUrl,
    required this.createdAt,
  });

  factory DocumentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DocumentModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      description: json['description']?.toString(),
      fileUrl: json['file_url']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
