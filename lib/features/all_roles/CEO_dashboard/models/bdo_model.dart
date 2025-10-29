class Bdo {
  final int id;
  final String name;
  final int? ceoUserId;

  Bdo({
    required this.id,
    required this.name,
    this.ceoUserId,
  });

  factory Bdo.fromJson(Map<String, dynamic> json) {
    return Bdo(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      ceoUserId: json['ceoUserId'] is int
          ? json['ceoUserId']
          : int.tryParse(json['ceoUserId']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'ceoUserId': ceoUserId,
  };
}
