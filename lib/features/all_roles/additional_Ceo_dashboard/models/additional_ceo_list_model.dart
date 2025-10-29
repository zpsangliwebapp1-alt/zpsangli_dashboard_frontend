class AdditionalCeoListModel {
  final int id;
  final String username;
  final int roleId;
  final String roleName;
  final int parentCeoId;
  final bool isActive;
  final DateTime createdAt;

  AdditionalCeoListModel({
    required this.id,
    required this.username,
    required this.roleId,
    required this.roleName,
    required this.parentCeoId,
    required this.isActive,
    required this.createdAt,
  });

  factory AdditionalCeoListModel.fromJson(Map<String, dynamic> json) {
    return AdditionalCeoListModel(
      id: json['id'],
      username: json['username'],
      roleId: json['roleId'],
      roleName: json['roleName'],
      parentCeoId: json['parentCeoId'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
