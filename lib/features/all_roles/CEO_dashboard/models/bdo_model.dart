class Bdo {
  final int id;
  final String name;
  final int? ceoUserId;

  Bdo({required this.id, required this.name, this.ceoUserId});

  factory Bdo.fromJson(Map<String, dynamic> json) {
    return Bdo(
      id: json['id'],
      name: json['name'],
      ceoUserId: json['ceoUserId'],
    );
  }
}
