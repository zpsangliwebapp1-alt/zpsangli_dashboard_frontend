class Broadcast {
  final int id;

  Broadcast({required this.id});

  factory Broadcast.fromJson(Map<String, dynamic> json) {
    return Broadcast(id: json['id']);
  }
}
