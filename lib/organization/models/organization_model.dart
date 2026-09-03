class OrganizationModel {
  final String id;
  final String? parentId;
  final String code;
  final String name;
  final String unitType;
  final String? region;
  final String? department;
  final String? commune;
  final String status;

  const OrganizationModel({
    required this.id,
    this.parentId,
    required this.code,
    required this.name,
    required this.unitType,
    this.region,
    this.department,
    this.commune,
    required this.status,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id']?.toString() ?? '',
      parentId: json['parent_id']?.toString(),
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      unitType: json['unit_type']?.toString() ?? '',
      region: json['region']?.toString(),
      department: json['department']?.toString(),
      commune: json['commune']?.toString(),
      status: json['status']?.toString() ?? 'ACTIVE',
    );
  }
}
