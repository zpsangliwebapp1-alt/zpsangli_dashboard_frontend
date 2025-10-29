import 'package:equatable/equatable.dart';

class BroadcastModel extends Equatable {
  final int id;
  final int type; // 1 = image, 2 = link
  final String messageText;
  final String? imageUrl; // ✅ corrected field name from imageStoredFileName
  final String? imageOriginalFileName;
  final String? imageContentType;
  final int? imageSizeBytes;
  final String? linkUrl;
  final int? createdBy;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final bool isApproved;

  const BroadcastModel({
    required this.id,
    required this.type,
    required this.messageText,
    this.imageUrl,
    this.imageOriginalFileName,
    this.imageContentType,
    this.imageSizeBytes,
    this.createdBy,
    this.linkUrl,
    this.expiresAt,
    required this.createdAt,
    required this.isApproved,
  });

  factory BroadcastModel.fromJson(Map<String, dynamic> json) {
    return BroadcastModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? 0,
      messageText: json['messageText'] ?? '',
      imageUrl: json['imageUrl'], // ✅ use imageUrl from API
      imageOriginalFileName: json['imageOriginalFileName'],
      imageContentType: json['imageContentType'],
      createdBy: json['createdBy'] is int
          ? json['createdBy']
          : int.tryParse(json['createdBy']?.toString() ?? ''),
      imageSizeBytes: json['imageSizeBytes'],
      linkUrl: json['linkUrl'],
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      isApproved: json['isApproved'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
    id,
    messageText,
    imageUrl,
    linkUrl,
    isApproved,
    createdAt,
  ];
}
