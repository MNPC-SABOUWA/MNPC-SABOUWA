class StatisticModel {
  final String id;
  final String statisticType;
  final int year;
  final String? region;
  final String? department;
  final String? commune;
  final int totalMembers;
  final int totalMen;
  final int totalWomen;
  final int totalYouth;

  const StatisticModel({
    required this.id,
    required this.statisticType,
    required this.year,
    this.region,
    this.department,
    this.commune,
    required this.totalMembers,
    required this.totalMen,
    required this.totalWomen,
    required this.totalYouth,
  });

  factory StatisticModel.fromJson(Map<String, dynamic> json) {
    return StatisticModel(
      id: json['id']?.toString() ?? '',
      statisticType: json['statistic_type']?.toString() ?? '',
      year: json['year'] is int
          ? json['year']
          : int.tryParse(json['year']?.toString() ?? '') ?? 0,
      region: json['region']?.toString(),
      department: json['department']?.toString(),
      commune: json['commune']?.toString(),
      totalMembers: _toInt(json['total_members']),
      totalMen: _toInt(json['total_men']),
      totalWomen: _toInt(json['total_women']),
      totalYouth: _toInt(json['total_youth']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
