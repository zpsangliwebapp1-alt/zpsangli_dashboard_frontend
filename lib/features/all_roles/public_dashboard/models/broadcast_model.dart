class PublicBroadcastModel {
  final String? imageUrl;
  final String? message;

  PublicBroadcastModel({
    this.imageUrl,
    this.message,
  });

  factory PublicBroadcastModel.fromJson(Map<String, dynamic> json) {
    return PublicBroadcastModel(
      imageUrl: json['imageUrl'] as String?,
      message: json['message'] as String?,
    );
  }
}
