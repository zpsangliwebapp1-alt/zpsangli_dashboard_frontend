// lib/features/complaint/data/models/complaint_response_model.dart

class ComplaintResponseModel {
  final int id;
  final String message;

  ComplaintResponseModel({
    required this.id,
    required this.message,
  });

  factory ComplaintResponseModel.fromJson(Map<String, dynamic> json) {
    int parsedId;
    if (json['id'] is int) {
      parsedId = json['id'] as int;
    } else {
      parsedId = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    }

    String parsedMessage = json['message']?.toString() ?? '';

    return ComplaintResponseModel(
      id: parsedId,
      message: parsedMessage,
    );
  }
}
