class CreateDepartment {
  final int id;
  final String name;
  final int bdoId;
  final int additionalCeoUserId;

  CreateDepartment({
    required this.id,
    required this.name,
    required this.bdoId,
    required this.additionalCeoUserId,
  });

  factory CreateDepartment.fromJson(Map<String, dynamic> json) {
    return CreateDepartment(
      id: json['id'],
      name: json['name'],
      bdoId: json['bdoId'],
      additionalCeoUserId: json['additionalCeoUserId'],
    );
  }
}
